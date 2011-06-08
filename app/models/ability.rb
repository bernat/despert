class Ability
  include CanCan::Ability

  def initialize(user)
    # Manage your own account
    can [:read, :update], User, :id => user.id

    if user.admin?
      can :manage, :all
    else
      can :read, Employee
      despert_abilities(user)
    end
  end

  def despert_abilities(user)
    can :create, Project
    can :read, Project, :employees => {:id => user.id}
    can :manage, Project, :manager_id => user.id

    can [:read, :create], Comment
    can [:update, :destroy], Comment, :user_id => user.id


    # Manage this models only from the projects the user participates in
    can :read, Milestone, :project => { :employees => {:id => user.id } }
    can :manage, Milestone, :project => { :manager_id => user.id }

    can [:read, :create], Message, :project => { :employees => {:id => user.id } }
    can [:update, :destroy], Message, :user_id => user.id

    can [:read, :create], Attachment, :project => { :employees => {:id => user.id } }
    can [:update, :destroy], Attachment, :employee_id => user.id

    can :read, TaskList, :project => { :employees => {:id => user.id } }
    can :manage, TaskList, :project => { :manager_id => user.id }

    can :read, Group
    can [:create, :update, :destroy], Group if user.admin? # convention for despert, #admin?

    can [:read, :create], Task, :task_list => { :project => { :employees => {:id => user.id } } }
    can :destroy, Task, :author_id => user.id
    can :destroy, Task, :employee_id => user.id
    can [:reassign_user, :edit_task_content], Task, :author_id => user.id, :completed_at => nil
    can :reassign_user, Task, :employee_id => nil, :completed_at => nil
    can [:reassign_user, :add_hours], Task, :employee_id => user.id, :completed_at => nil
    can :toggle_task, Task, :employee_id => user.id
    can :archive_toggle_task, Task, :employee_id => user.id
    can :reorder, Task, :author_id => user.id, :completed_at => nil
    can :reorder, Task, :employee_id => user.id, :completed_at => nil
    # The manager can do anything about the tasks of their projects
    can :manage, Task, :task_list => {:project => { :manager_id => user.id } }
    # for convenience, this is a sort of ability grouping. :update ability ==
    # [:edit_task_content || :toggle || :reassign || :add_hours]
    can :update, Task, :author_id => user.id, :completed_at => nil
    can :update, Task, :employee_id => user.id
    can :update, Task, :employee_id => nil, :completed_at => nil
  end
end
