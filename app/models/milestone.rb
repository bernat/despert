class Milestone < ActiveRecord::Base
  include Intranet::DateFormat

  fire_events :background => :project, :context => :project, :except => :update

  belongs_to :project

  has_many :task_lists
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :events, :as => :subject, :dependent => :destroy
  has_many :events_as_context, :class_name => 'Event', :as => :context

  validates_presence_of :name
  validates_presence_of :project
  validates_presence_of :finishes_at

  default_scope order('finishes_at ASC')

  scope :upcoming, where("finishes_at >= ?", Date.today)
  scope :marked_completed, where(:completed => true)
  scope :marked_uncompleted, where(:completed => false)
  scope :all_for_employee, lambda{|e| joins(:project => :memberships).where(:memberships => {:employee_id => e.id})}

  before_update :generate_proper_events

  def planned_duration
    task_lists.map{|x| x.hours || 0}.sum
  end

  def real_duration
    task_lists.map{|x| x.total_hours}.sum
  end

  def to_s
    name
  end

  def friendly_date
    res = ""
    diff = (Date.today - finishes_at.to_date).numerator.abs
    if Date.today > finishes_at
      res << "(acabat fa #{diff} dies)"
    else
      res << "(queden #{diff} dies)"
    end
    res
  end

  def finishes_at=(value)
    self[:finishes_at] = format_input_date(value)
  end

  def new_comment(comment)
    recipients = Comment.notification_recipients_for(comments, comment)
    recipients << project.manager unless recipients.include?(project.manager) || project.manager == comment.user

    recipients.each do |x|
      Delayed::Job.enqueue NotifierMailerJob.new(:new_comment, x, comment)
    end
  end

  def generate_proper_events
    generate_event(:event_type => "modified")

    if finishes_at_changed?
      generate_event(:event_type => "postponed", :subdescrip => "Milestone aplaçat fins a: #{finishes_at}")
    end
  end

  def get_postponed_events
    events.where(:event_type => "postponed")
  end
end

