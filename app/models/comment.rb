class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user

  validates_presence_of :content, :on => :create, :message => "No has escrit res!"

  scope :recent, where(Comment.arel_table[:created_at].gt(Date.today - 1.weeks))
  default_scope :order  => 'created_at ASC'

  validates_presence_of :user, :commentable

  after_create :creation_callback

  def to_s
    content
  end

  alias actor user


  detect_mentions :inside => :content, :candidates => :mentionable_users, :do => :notify_mention

  def mentionable_users
    commentable.project.employees
  end

  def notify_mention(users)
    users.each do |x|
      Delayed::Job.enqueue MentionsMailerJob.new(:mention_in_comment, x, self)
    end
  end

  def creation_callback
    commentable.new_comment(self) if commentable.respond_to?(:new_comment)
  end

  # Selects who has to be notified when a new comment is created.
  # First argument is the previous existing comments over a given subject
  def self.notification_recipients_for(comments, new_comment)
    recipients = comments.map{|x| x.user}.uniq
    recipients -= [new_comment.user]
    recipients
  end
end

