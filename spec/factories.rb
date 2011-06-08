Factory.define :group do |group|
  group.sequence(:ref) {|x| "ref_#{x}"}
  group.sequence(:name) {|x| "Group number #{x}"}
end
Factory.define :employee do |employee|
  employee.password  "password"
  employee.sequence(:name) {|x| "Stub user ##{x}"}
  employee.sequence(:email) {|x| "user_#{x}@itnig.net"}
  employee.nif { Factory.next(:nif) }
  employee.phone { Factory.next(:phone) }
  employee.bank_account { Factory.next(:bank_account) }
  employee.bank_name "Itnig International Bank"
  employee.association(:group)
end


Factory.define :project do |project|
  project.sequence(:name) {|x| "Project cool #{x}"}
  project.sequence(:ref) {|x| "proj_#{x}"}
  project.starting_date  Date.today - 5.days

  project.after_build do |p|
    a = Factory :employee
    p.manager = a
    p.employees << a
  end
end


Factory.define :project_type do |f|
  f.name   "Basic"
  f.monthly_fee     65
  f.comission       65
  f.months_of_comission 3
end
