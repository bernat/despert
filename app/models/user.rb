class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :receive_emails, :lang, :admin, :group_id, :username

  def admin?
    role == "admin"
  end
end
