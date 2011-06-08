class Group < ActiveRecord::Base
  has_many :employees
  has_many :task_lists


  validates_presence_of :ref, :name
  validates_uniqueness_of :ref

  def to_s
    name
  end

  def hours_of_work(project)
    hours = 0
    project.task_lists.each do |task_list|
      if task_list.group == self
        task_list.tasks.each  do |task|
          if !task.completed_at.nil?
            hours = hours + task.duration if task.duration
          end
        end
      end
    end
    return hours
  end
end
