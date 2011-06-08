class NotifierMailer < ActionMailer::Base
  default :from => "intranet@itnig.net"

  def assigned_in_a_task(employee, task)
    @employee = employee
    @task = task

    mail :to => employee.email, :subject => "[Intranet] Has estat assignat/da a una tasca"
  end

  def new_comment(user, comment)
    @user = user
    @comment = comment

    mail :to => user.email, :subject => "[Intranet] Nou comentari a on tu participes"
  end
end

