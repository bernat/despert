class Employee < User
  has_many :messages
  has_many :comments
  has_many :memberships
  has_many :projects, :through => :memberships
  has_many :managed_projects, :class_name => "Project", :foreign_key => "manager_id"
  has_many :events, :as => :actor
  has_many :tasks

  belongs_to :group

  validates_presence_of :email
  validates_presence_of :username
  validates :name, :presence => true
  validates_uniqueness_of :username

  before_validation :set_default_username

  def viewable_events
    # Nomes veu per ara events relacionats amb projectes, que son els de
    # despert
    Event.with_backgrounds("Project", project_ids).includes([ :background, :subject, :context, :actor ])
  end

  def milestones
    Milestone.all_for_employee(self)
  end

  def to_param
    username
  end

  def username=(value)
    self[:username] = value.downcase.to_ascii.gsub(/[^[:alnum:]]/,'-')
  end

  def to_s
    name
  end

protected
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def set_default_username
    self.username = email.partition(/@/).first if username.blank?
  end
end
