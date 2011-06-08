class Receiver < ActionMailer::Base
  def receive(email)
    if email.multipart?
      if email.html_part.present?
        ic = Iconv.new('utf-8', email.html_part.charset)
        body = ic.iconv(email.html_part.body.to_s)
        subject = ic.iconv(email.subject)
        footer = "html_footer"
      else
        ic = Iconv.new('utf-8', email.text_part.charset)
        body = ic.iconv(email.text_part.body.to_s)
        footer = "text_footer"
      end
    else
      ic = Iconv.new('utf-8', email.charset)
      body = ic.iconv(email.body.to_s)
      footer = "text_footer"
    end
    subject = ic.iconv(email.subject)
    EMAIL_LOGGER.info("[IN] Parsed incoming email [#{email.subject}] from [#{email.from}]")

    object_ref, type = find_object(subject, email.from)

    if object_ref
      from_user = User.find_by_email(email.from)

      if type == "Project"
        project = Project.where("upper(ref) = ?", object_ref.upcase).first

        if email.has_attachments?
          @attachs = []

          email.attachments.each do |attach|
            if from_user.nil?
              emp = nil
            else
              emp = from_user
            end

            tmp = StringIO.new(attach.read)
            tmp.instance_eval <<-RUBY, __FILE__, __LINE__+1
              def original_filename
                "#{attach.filename}"
              end
            RUBY

            a = nil
            Intranet::Events.skip_events do
              a = Attachment.create :attach => tmp,
                                    :description => "File sended via email by #{email.from}",
                                    :project => project,
                                    :employee => emp,
                                    :author => from_user.nil? ? email.from.to_s : from_user.to_s
            end
            a.generate_event(:event_type => "new", :actor => from_user)

            @attachs << a
          end
        end

        @email = email
        body = body + eval("#{footer}")

        mes = nil
        Intranet::Events.skip_events do
          mes = Message.create :subject => subject,
                              :body => body.to_s,
                              :user => from_user,
                              :author => from_user.nil? ? email.from.to_s : from_user.to_s,
                              :project => project,
                              :html => email.html_part.present?,
                              :from_email => true,
                              :created_at => email.date if email.has_date?
        end

        mes.generate_event(:event_type => "new", :actor => from_user)
      end

    end
  end

private
  def find_object(subject, from)
    subject =~ /#(\w+)/
    if $1
      ref = Project.where("upper(ref) = ?", $1.upcase).first
      ref = ref.ref if ref
    end
    [ref, "Project"]
  end

  def text_footer
    render_to_string('messages/email_footer.text.erb')
  end

  def html_footer
    render_to_string('messages/email_footer.html.erb')
  end
end

