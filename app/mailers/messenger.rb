class Messenger
  class Notification
    attr_reader :recipients, :assumpte

    def initialize(event)
      @event = event
      @subject = event.subject
      @actor = event.actor
      setup #To implement by subclasses
      turn_recps_into_mails
    end

    def turn_recps_into_mails
      @recipients = @recipients.map{|x| x.email if x.receive_emails}.select{|x| !x.nil?}
    end

    def setup_context(instance)
      subject_name = "@#{@subject.class.name.underscore}"
      instance.instance_variable_set(subject_name, @subject)
      instance.instance_variable_set("@actor", @actor)
      instance.instance_variable_set("@event", @event)
    end
  end

  class TaskNotification < Notification
    def setup
      @assumpte = "[#{@event.context.get_ref}] #{@event.event_type.humanize}: #{@event.subdescrip}"

      #Notifiquem nomes a l'usuari asignat si n'hi ha
      if @subject && @subject.employee
        @recipients = [@subject.employee]

      #Notifiquem a la gent del grup de la tasklists si n'hi ha
      elsif @subject && @subject.task_list.group
        @recipients = @subject.task_list.group.employees

      #Notifiquem a tota la gent del projecte
      else
        @recipients = @event.background.employees
      end

      @recipients << @event.background.manager unless @recipients.include?(@event.background.manager)
    end
  end

  class TaskListNotification < Notification
    def setup
      @assumpte = "[#{@event.context.get_ref}] #{@event.event_type.humanize}: #{@event.subdescrip}"
      @recipients = @event.background.employees
    end
  end

  class MilestoneNotification < Notification
    def setup
      @assumpte = "[#{@event.context.get_ref}] #{@event.event_type.humanize}: #{@event.subdescrip}"
      @recipients = @event.background.employees
    end
  end

  class ProjectNotification < Notification
    def setup
      if @subject
        @assumpte = "[#{@subject.get_ref}] #{@event.event_type.humanize}: #{@subject.name}"
        @recipients = @subject.employees
      else
        @assumpte = "Deleted project #{@event.subdescrip}"
        @recipients = Employee.all
      end
    end
  end

  class MessageNotification < Notification
    def setup
      @assumpte = "[#{@event.context.get_ref}] #{@event.event_type.humanize}: #{@event.subdescrip}"
      @recipients = @event.background.employees
    end
  end

  class AttachmentNotification < Notification
    def setup
      @assumpte = "[#{@event.context.get_ref}] #{@event.event_type.humanize}: #{@event.subdescrip}"
      @recipients = @event.background.employees
    end
  end

  class ClientNotification < Notification
    def setup
      @assumpte = "#{@event.event_type.humanize}: #{@event.subdescrip}"
      @recipients = Employee.all
    end
  end

  class CommentNotification < Notification
    def setup
      @assumpte = "#{@event.event_type.humanize}: #{@event.subdescrip}"
      if @event.background
        @recipients = @event.background.employees
      else
        @recipients = Employee.all
      end
    end
  end


  def self.send_event_email(event)
    note = eval("#{event.subject_type}Notification").new(event)
    mes = EventMailer.send(event.event_type, note)
    mes.deliver unless note.recipients.blank?
  end
end

