module Intranet
  module Events

    mattr_accessor :whodunnit
    mattr_accessor :no_events
    @@no_events = false

    def self.skip_events
      Intranet::Events.no_events = true
      yield
      Intranet::Events.no_events = false
    end

    module ClassMethods
      def fire_events(opts = {})
        class_inheritable_accessor :eventable_options
        self.eventable_options = opts.dup
        if eventable_options.has_key?(:except) && eventable_options[:except].is_a?(Symbol)
          eventable_options[:except] = [eventable_options[:except]]
        end

        make_it_eventable! unless included_modules.include? InstanceMethods
      end

      private

      def make_it_eventable!
        include InstanceMethods

        after_update :update_event
        after_create :create_event
        # Don't generate destroy events by now since it breaks events listing
        #after_destroy :destroy_event
      end
    end

    module InstanceMethods
      def generate_event(opts = {})
        return if Intranet::Events.no_events
        return unless valid?

        unless opts.has_key?(:event_type)
          raise ArgumentError, "You need to provide a :event_type string"
        end

        opts[:subject] ||= self
        opts[:actor] ||= Intranet::Events.whodunnit
        opts[:author] ||= opts[:actor].to_s
        opts[:published] = true
        opts[:event_type] << "_#{self.class.to_s.underscore}"
        opts[:subdescrip] ||= I18n.t(opts[:event_type])

        if eventable_options.has_key?(:background)
          opts[:background] = eventable_options[:background] == :self ? self : self.send(eventable_options[:background])
        end
        if eventable_options.has_key?(:context)
          opts[:context] = eventable_options[:context] == :self ? self : self.send(eventable_options[:context])
        end

        Event.create! opts
      end

      private

      def create_event
        generate_event(:event_type => "new") unless eventable_options[:except] && eventable_options[:except].include?(:create)
      end

      def update_event
        generate_event(:event_type => "modified") unless eventable_options[:except] && eventable_options[:except].include?(:update)
      end

      def destroy_event
        generate_event(:event_type => "destroyed") unless eventable_options[:except] && eventable_options[:except].include?(:destroy)
      end
    end

  end
end

ActiveRecord::Base.extend Intranet::Events::ClassMethods

