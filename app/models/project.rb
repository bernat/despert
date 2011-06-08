class Project < ActiveRecord::Base
  include Intranet::DateFormat
  has_paper_trail :only => [:status_description]

  fire_events :background => :self, :context => :self, :except => :update

  STATUS_LIST = [[0, "Queued"], [1, "Working"], [2, "Priority"], [3, "Urgent"]]
  STATES_LIST = ["running", "halted", "closed"]

  belongs_to :project_type
  belongs_to :manager, :class_name => 'Employee'

  has_many :memberships
  has_many :employees, :through => :memberships

  has_many :events, :as => :subject, :dependent => :destroy
  has_many :events_as_background, :class_name => 'Event', :as => :background, :include => [ :background, :subject, :context, :actor ]

  has_many :milestones, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :task_lists, :dependent => :destroy
  has_many :tasks, :through => :task_lists
  has_many :attachments, :dependent => :destroy

  validates_presence_of :project_type
  validates :ref,
      :presence => true,
      :uniqueness => true,
      :length => {:in => 4..15}

  validates :manager, :presence => true

  validates :employees, :presence => true
  validates_presence_of :starting_date
  validate :pm_is_an_employee

  default_scope order('status DESC', 'updated_at DESC')

  scope :running, where(:state => "running")
  scope :recent, lambda { |*period| where("updated_at > ?", (Date.today - (period.first || 15.days)).to_time.in_time_zone('UTC')) }
  scope :started_between, lambda { |date_ini, date_end| where(:starting_date => date_ini.to_time.in_time_zone('UTC')..date_end.to_time.in_time_zone('UTC')) }

  before_validation :downcaize_ref
  before_create :create_unassigned_task_list
  before_update :launch_events

  def get_ref
    "##{ref}"
  end

  def get_status
    Hash[STATUS_LIST][status]
  end

  def calculate_total_hours
    task_lists.map{|x| x.total_hours}.sum
  end

  def completed_hours
    task_lists.map{|x| x.completed_hours}.sum
  end

  def last_tasks(fromdate)
    i = 19
    last_hours = []
    while i >= 0
      last_hours << [fromdate - i, self.tasks.where("date(completed_at) = ?", fromdate - i).sum('duration')]
      i = i - 1
    end
    return last_hours
  end

  def get_events
    events_as_background
  end

  def to_s
    name
  end

  def create_unassigned_task_list
    self.task_lists.build(:name => "unassigned")
  end

  def to_color
    "##{project_type.color}" || "#EEE" unless project_type.blank?
  end

  def starting_date=(value)
    self[:starting_date] = format_input_date(value)
  end

  def to_param
    self[:ref]
  end

  def ref
    self[:ref].upcase
  end

private
  def downcaize_ref
    self.ref.gsub!(/[^A-Za-z]/, "")
    self.ref.downcase!
  end

  def pm_is_an_employee
    errors.add(:manager, "must participate in this project") unless employees.include?(manager)
  end

  def launch_events
    if status_description_was != status_description
      generate_event(:event_type => "status_update", :subdescrip => "Status canvia de \"#{status_description_was}\" a \"#{status_description}\"")
    end
  end
end
