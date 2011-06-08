class EventMailer < ActionMailer::Base
  default :from => "#{APP_CONFIG['app']} <#{APP_CONFIG['mail']['account']['user_name']}>", :charset => "utf-8"

  @@bloc = <<BLOCK
    note.setup_context self
    mail(:to => note.recipients, :subject => note.assumpte)
BLOCK

# ============ TASKS ===================================================
  def new_task(note)
    eval @@bloc
  end

  def modified_task(note)
    eval @@bloc
  end

  def destroyed_task(note)
    eval @@bloc
  end

  def completed_task(note)
    eval @@bloc
  end

  def reopened_task(note)
    eval @@bloc
  end

  def reordered_task(note)
    eval @@bloc
  end

# =========== TASKLISTS ==================================================
  def new_task_list(note)
    eval @@bloc
  end

  def modified_task_list(note)
    eval @@bloc
  end

  def destroyed_task_list(note)
    eval @@bloc
  end

# ============= MILESTONES ==============================================
  def new_milestone(note)
    eval @@bloc
  end

  def modified_milestone(note)
    eval @@bloc
  end

  def destroyed_milestone(note)
    eval @@bloc
  end

# ============ MESSAGES =================================================
  def new_message(note)
    eval @@bloc
  end

  def modified_message(note)
    eval @@bloc
  end

  def destroyed_message(note)
    eval @@bloc
  end

# ============ COMMENTS ================================================
  def new_comment(note)
    eval @@bloc
  end

  def destroyed_comment(note)
    eval @@bloc
  end

# =========== ATTACHMENTS ==============================================
  def new_attachment(note)
    eval @@bloc
  end

  def modified_attachment(note)
    eval @@bloc
  end

  def destroyed_attachment(note)
    eval @@bloc
  end

# =========== PROJECTS =================================================
  def new_project(note)
    eval @@bloc
  end

  def modified_project(note)
    eval @@bloc
  end

  def destroyed_project(note)
    eval @@bloc
  end
end
