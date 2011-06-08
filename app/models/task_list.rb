class TaskList < ActiveRecord::Base
  fire_events :background => :project, :context => :project
  has_paper_trail :only => [:hours, :description], :meta => {:concept => :concept}

  has_many :tasks, :order => 'position ASC, completed_at DESC', :dependent => :destroy
  has_many :events, :as => :subject, :dependent => :destroy

  belongs_to :milestone
  belongs_to :group
  belongs_to :project

  validates_presence_of :name
  validates_presence_of :project
  validate :all_completed_tasks_when_archived

  attr_accessor :concept

  before_destroy :prevent_unassigned_deletion
  validate :concept_of_change_missing

  scope :archived, where(:archived => true)
  scope :unarchived, where(:archived => false)

  def total_hours
    tasks.map{|x| x.duration}.sum
  end

  def completed_hours
    tasks.completed.map{|x| x.duration}.sum
  end

  def completed_tasks_done
    tasks.completed.count
  end

  def to_s
    name
  end

  def toggle_archive
    self.archived = !archived
  end

  def increment_positions_from(position)
    tasks.where(Task.arel_table[:position].gt(position)).each do |t|
      t.position += 1
      t.save!
    end
  end

private
  def prevent_unassigned_deletion
    errors.add(:base, "No es pot esborrar la llista unassigned") if name == "unassigned"
  end

  def all_completed_tasks_when_archived
    errors.add(:base, "No pots arxivar-la si encara té tasques pendents") if archived? && tasks.uncompleted.any?
  end

  def concept_of_change_missing
    errors.add(:base, "Has d'explicar la raó dels canvis") if hours_changed? && concept.blank?
  end
end

