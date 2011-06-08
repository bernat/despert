class Event < ActiveRecord::Base
  belongs_to :actor, :polymorphic => true
  belongs_to :subject, :polymorphic => true
  belongs_to :context, :polymorphic => true
  belongs_to :background, :polymorphic => true

  default_scope where(:published => true).order('created_at DESC')

  validates_presence_of :subdescrip
  validates_presence_of :subject

  scope :with_no_context, where(:context_id => nil)
  scope :with_no_background, where(:background_id => nil)
  scope :with_backgrounds, lambda {|bg_type, ids| where(:background_type => bg_type).where(:background_id => ids)}
  scope :recent, where(Event.arel_table[:created_at].gt(Date.today - 1.weeks))

  def self.unpublished
    with_exclusive_scope{Event.where(:published => false)}
  end

  def self.prepare_for_view(events)
    @events = events.group_by{|x| x.subject }

    @events.each do |sub, events|
      if sub.respond_to?(:comments) && sub.comments.any?
        @events[sub] = ( events + sub.comments.recent )
      end
      @events[sub].sort!{|a, b| a.created_at <=> b.created_at}
    end

    @events = @events.to_a.sort{|a,b| b.last.last.created_at <=> a.last.last.created_at }
  end
end

