class Mentions < ActionMailer::Base
  default :from => "intranet@itnig.net"

  def mention_in_message(user, message)
    @user = user
    @message = message
    mail :to => user.email, :subject => "[Intranet] Has estat mencionat en el missatge #{message.subject}"
  end

  def mention_in_comment(user, comment)
    @user = user
    @comment = comment
    mail :to => user.email, :subject => "[Intranet] Has estat mencionat en un comentari per #{comment.user}"
  end
end
