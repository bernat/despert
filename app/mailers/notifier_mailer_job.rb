class NotifierMailerJob
  def initialize(method, employee, object)
    @method = method
    @employee_id = employee.id
    @object_type = object.class.to_s
    @object_id = object.id
  end

  def perform
    user = Employee.find(@employee_id)
    object = @object_type.classify.constantize.find @object_id
    NotifierMailer.send(@method, user, object).deliver
  end
end


