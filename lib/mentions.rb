module Intranet
  module Mentions
    module ClassMethods
      def detect_mentions(opts = {})
        class_inheritable_accessor :mentionable_options
        self.mentionable_options = opts.dup

        make_it_mentionable! unless included_modules.include? InstanceMethods
      end

      private

      def make_it_mentionable!
        include InstanceMethods
        after_save :parse_mentions
      end
    end

    module InstanceMethods
      def parse_mentions
        regexp = /@\w+/

        if mentionable_options[:inside].is_a? Array
          mentions = mentionable_options[:inside].map{|x| send(x).scan(regexp)}.sum
        else
          mentions = send(mentionable_options[:inside]).scan(regexp)
        end
        return if mentions.empty?

        mentions = mentions.uniq.map{|x| x[1..-1]}

        candidates = send(mentionable_options[:candidates])

        unless mentions.include?("all")
          candidates = candidates.select{|x| mentions.include?(x.username)}
        end
        send(mentionable_options[:do], candidates) if candidates.any?
      end
    end

  end
end

ActiveRecord::Base.extend Intranet::Mentions::ClassMethods
