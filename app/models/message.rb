class Message < ActiveRecord::Base
  fire_events :background => :project, :context => :project

  belongs_to :user
  belongs_to :project

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :events, :as => :subject, :dependent => :destroy
  has_many :events_as_context, :class_name => 'Event', :as => :context

  validates_presence_of :author
  validates_presence_of :body
  validates_presence_of :project
  validates_presence_of :subject

  default_scope order('updated_at DESC')

  scope :created_after, lambda { |from| where("messages.created_at >= ?", Time.now - from) }

  def to_s
    subject
  end

  def get_background_color
    unless user.blank?
      user.group.blank? ? "EEE" : user.group.color.gsub("00", "EE") if user.respond_to?(:group)
    else
      "FFF"
    end
  end

  detect_mentions :inside => [:body, :subject], :candidates => :mentionable_users, :do => :notify_mention

  def mentionable_users
    project.employees
  end

  def notify_mention(users)
    users.each do |x|
      Delayed::Job.enqueue MentionsMailerJob.new(:mention_in_message, x, self)
    end
  end

  def new_comment(comment)
    recipients = Comment.notification_recipients_for(comments, comment)
    recipients << user if user && !recipients.include?(user) && comment.user != user

    recipients.each do |x|
      Delayed::Job.enqueue NotifierMailerJob.new(:new_comment, x, comment)
    end
  end

end

