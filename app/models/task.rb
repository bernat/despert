class Task < ActiveRecord::Base
  fire_events :background => :project, :context => :project, :except => :update

  belongs_to :task_list
  belongs_to :employee
  belongs_to :author, :class_name => 'Employee'

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :events, :as => :subject, :dependent => :destroy
  has_many :events_as_context, :class_name => 'Event', :as => :context
  delegate :project, :to => :task_list

  validates :title, :presence => true, :length => { :maximum => 80 }
  validates :position, :presence => true, :numericality => true, :allow_nil => false
  validate :unique_title

  validates_presence_of :author
  validates_presence_of :task_list
  validates_presence_of :duration

  validates_presence_of :employee, :if => :completed?
  validates :duration, :numericality => {:greater_than => 0}, :if => :completed?

  scope :active, where(:closed => false)
  scope :closed, where(:closed => true)
  scope :completed, active.where("completed_at IS NOT NULL")
  scope :uncompleted, active.where("completed_at IS NULL")
  scope :completed_between, lambda { |date_ini, date_end| active.where(:completed_at => date_ini.to_time.in_time_zone('UTC')..date_end.to_time.in_time_zone('UTC')) }
  scope :latest_completed, active.completed.order("completed_at DESC")
  scope :latest_uncompleted, active.uncompleted.order("updated_at DESC")
  scope :planned, uncompleted.joins(:task_list => :milestone).order("finishes_at ASC, position ASC, tasks.updated_at DESC")
  scope :unplanned, latest_uncompleted.joins(:task_list).where(:task_lists => {:milestone_id => nil})

  before_save :set_old_employee_id
  after_save :notify_assigned_employee

  def to_s
    title
  end

  def toggle
    unless completed?
      self.completed_at = Time.now
      self.position = 0
      generate_event(:event_type => "completed", :subdescrip => "Tasca completada")
    else
      max = task_list.tasks.uncompleted.maximum('position') || 0
      self.completed_at = nil
      self.position = max + 1
      generate_event(:event_type => "reopened", :subdescrip => "Tasca reoberta")
    end
  end

  def archive_toggle
    if closed
      self.closed = false
      generate_event(:event_type => "archived", :subdescrip => "Tasca desarxivada")
    else
      self.closed = true
      generate_event(:event_type => "unarchived", :subdescrip => "Tasca arxivada")
    end
  end

  def edit_content(params)
    self.title = params[:task][:title]
    self.description = params[:task][:description]
    generate_event(:event_type => "modified") if (title_changed? || description_changed?)
  end

  def reassign_user(params)
    self.employee_id = params[:task][:employee_id]
    generate_event(:event_type => "reassigned_user", :subdescrip => "Tasca assignada a #{employee}") if employee_id_changed?
  end

  def add_hours(params)
    self.duration = params[:task][:duration]
    generate_event(:event_type => "add_hours", :subdescrip => "Hores modificades: #{duration_was} -> #{duration}") if duration_changed?
  end

  def completed?
    completed_at.present?
  end

  def move_to(tl, task)
    self.task_list = tl
    # task is the previous task in order, we must put ourself after it
    if task
      tl.increment_positions_from(task.position)
      self.position = task.position + 1
    else
      self.position = tl.tasks.minimum(:position) - 1
    end

    if valid?
      if task_list_id_was == tl.id
        if tl.tasks.minimum(:position) - 1 == position
          text = "La tasca ara és la més important de #{tl}"
        else
          text = "Tasca canviada de prioritat"
        end
        generate_event(:event_type => "sorted", :subdescrip => text)
      else
        generate_event(:event_type => "moved", :subdescrip => "Tasca moguda a la llista #{task_list}")
      end
    end
  end

  def new_comment(comment)
    recipients = Comment.notification_recipients_for(comments, comment)
    recipients << employee if employee && !recipients.include?(employee) && comment.user != employee

    recipients.each do |x|
      Delayed::Job.enqueue NotifierMailerJob.new(:new_comment, x, comment)
    end
  end

private
  def unique_title
    errors[:title] << " ha de ser unic a la llista de tasques" if task_list.tasks.where(:title => title).count == 1 and new_record?
  end

  def set_old_employee_id
    # We need to enqueue a job with a real self.id, so it must be performed on
    # after_save. But, to check if employee_id was changed we need to keep
    # this information!
    @employee_id_was = employee_id_was
  end

  def notify_assigned_employee
    if employee_id != @employee_id_was && employee_id != author_id
      #NotifierMailer.assigned_in_a_task(employee, self).deliver
      Delayed::Job.enqueue NotifierMailerJob.new(:assigned_in_a_task, employee, self)
    end
  end
end

