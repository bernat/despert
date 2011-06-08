module Intranet
  module Events
    module Controller
      def self.included(base)
        base.before_filter :set_events_whodunnit
      end

      protected

      def user_for_events
        current_user rescue nil
      end

      private

      def set_events_whodunnit
        Intranet::Events.whodunnit = user_for_events
      end
    end
  end
end

ActionController::Base.send :include, Intranet::Events::Controller
