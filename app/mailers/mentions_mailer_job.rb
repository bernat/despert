class MentionsMailerJob
  def initialize(method, user, object)
    @method = method
    @user_id = user.id
    @object_type = object.class.to_s
    @object_id = object.id
  end

  def perform
    user = User.find(@user_id)
    object = @object_type.classify.constantize.find_by_id @object_id
    return if object.nil?
    Mentions.send(@method, user, object).deliver
  end
end

