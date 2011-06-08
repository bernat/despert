class Attachment < ActiveRecord::Base
  fire_events :background => :project, :context => :project

  belongs_to :project
  belongs_to :employee

  has_many :events, :as => :subject, :dependent => :destroy

  default_scope order('created_at DESC')

  mount_uploader :attach, AttachmentUploader


  def filename
    File.basename attach.path
  end

  def to_s
    filename
  end

  def get_file_url
    if APP_CONFIG['storage'] == :s3
      attach.file.authenticated_url
    else
      attach.url
    end
  end

end

