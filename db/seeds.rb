
#Beginning of the Seed Data

puts "=> BEGIN SEED DATA (in catalan)\n"

# Make sure possible errors have translations
I18n.locale = :en

usernames = [ {:name => 'Bernat Farrero', :email => 'bernat@itnig.net' },
              {:name => 'Roger Campos', :email => 'roger@itnig.net' },
              {:name => "Dulce d'La Rosa", :email => 'dulce@itnig.net' },
              {:name => "Albert Bellonch", :email => 'albert@itnig.net' },
              {:name => "Sergi Sans", :email => 'sergi@itnig.net' }
            ]

puts "Creating #{usernames.count} users"

PASSWD = 'password'
users = []

Employee.delete_all
usernames.each do |x|
  a = Employee.create!(:name => x[:name], :email => x[:email], :password => PASSWD, :password_confirmation => PASSWD, :role => :employee)
  users << a
  puts "  Created employee #{x[:name]}"
end

admin = Employee.create! :name => "Admin user", :email => "admin@itnig.net", :password => PASSWD, :role => :admin
dani = Employee.create! :name => "Dani Mata", :email => "dani@itnig.net", :password => PASSWD

accountant = Employee.create! :name => "Gestor de itnig", :email => "accountant@itnig.net", :password => PASSWD, :role => :accountant
administrative = Employee.create! :name => "Administratiu d'Itnig",
  :email => "administrative@itnig.net", :password => PASSWD, :role => :administrative


roger = Employee.find_by_email('roger@itnig.net')
bernat = Employee.find_by_email('bernat@itnig.net')
dulce = Employee.find_by_email('dulce@itnig.net')
sergi = Employee.find_by_email('sergi@itnig.net')
albert = Employee.find_by_email 'albert@itnig.net'

albert.update_attributes :bank_name => "La caixa", :bank_account => "21005651241512515125",
  :billing_cif => "0000000T",
  :billing_name => "Albert Bellonch",
  :billing_province => "Barcelona",
  :billing_country => "España",
  :billing_town => "Barcelona",
  :billing_zip => "08021",
  :billing_address => "Calle falsa 123"
sergi.update_attributes :bank_name => "La caixa", :bank_account => "21009865454444443535636",
  :billing_cif => "0000000T",
  :billing_name => "Sergi Sans",
  :billing_province => "Barcelona",
  :billing_country => "España",
  :billing_town => "Barcelona",
  :billing_zip => "08021",
  :billing_address => "Calle falsa 453"

puts "Creating some Groups"
Group.delete_all
g_eng = Group.create!(:name => 'Enginyeria', :description => "Son els enginyers els millors vamos", :ref => "IT", :color => "FF0000", :email => "it@itnig.net")
g_mark = Group.create!(:name => 'Marketing', :description => "Tracte amb el client i comercials", :ref => "MKT", :color => "00FF00", :email => "mkt@itnig.net")
g_dis = Group.create!(:name => 'Disseny', :description => "Dissenyadors web HTML i CSS", :ref => "DES", :color => "0000FF", :email => "design@itnig.net")
g_man = Group.create!(:name => 'Gestió', :description => "Gestió de projectes", :ref => "MAN", :color => "FFFF00", :email => "projects@itnig.net")

puts "---- #{g_eng}"
roger.group = g_eng
roger.save!
bernat.group = g_man
bernat.save!
dulce.group = g_dis
dulce.save!
sergi.group = g_mark
sergi.save!
dani.group = g_mark
dani.save!

puts "Creating some project types"
ProjectType.delete_all
pe1 = ProjectType.create!(:name => 'basic', :description => "Pla Bàsic", :monthly_fee => 65.0, :color => "18485c")
pe2 = ProjectType.create!(:name => 'standard', :description => "Pla Estàndar",  :monthly_fee => 120.0, :color => "e06441")
pe3 = ProjectType.create!(:name => 'advanced', :description => "Pla Avançat",  :monthly_fee => 220.0, :color => "a32500")
pe4 = ProjectType.create!(:name => 'maintenance', :description => "Pla de manteniment d'aplicació", :monthly_fee => 20.0, :color => "333")
pe_internal = ProjectType.create! :name => "intern", :description => "Projectes interns", :monthly_fee => 0, :internal => true, :color => "888"


puts "Creating some projects"

Project.delete_all
pj1 = Project.new(:name => 'Mantra',
                  :starting_date => Date.today - 5.months,
                  :info => "Desenvolupament de la intranet d'Itnig",
                  :ref => "mantra",
                  :state  => "running",
                  :project_type => pe_internal)
pj1.employees << roger << users[4]
pj1.manager = roger
pj1.save!

pj2 = Project.new(:name => 'MagdaCroquer',
                  :starting_date => Date.today - 4.months,
                  :info => "Pàgina encarada sobretot al SEO.",
                  :project_type => pe1,
                  :ref => "magda",
                  :state  => "running")
pj2.employees << bernat << users[2] << users[3] << users[1] << users[0] << dani
pj2.manager = bernat
pj2.save

pj3 = Project.new(:name => 'Gafasparatodos.com', :starting_date => Date.today - 4.month,
                  :info => "El producte consisteix en una aplicació web per a la venta d'ulleres per Internet",
                  :project_type_id => pe3.id, :ref => "gafas", :state  => "running")
pj3.employees << albert << users[3] << users[2] << users[4]
pj3.manager = albert
pj3.save


camaloon = Project.new :name => "Camaloon", :starting_date => Date.today - 6.months, :info => "Pagina de camaloon", :project_type => pe3, :ref => "camaloon", :variable => true, :production_hostname => "camaloon.com"

camaloon.employees << albert << roger << bernat
camaloon.manager = roger
camaloon.save!

puts "Creating some project messages"

Message.delete_all
m1 = Message.create!(:subject => "Lorem Ipsum", :body => "Lorem ipsum pixum de gat", :user => users[3], :project => pj1, :author => users[3])
m2 = Message.create!(:subject => "¿Por qué los de lepe no entran a la cocina?", :body => "- Porque hay un bote que pone sal", :user => users[3], :project => pj1, :author => users[3])
m3 = Message.create!(:subject => "Titol 1", :body => "Cos del missatge", :user => users[2], :project => pj2, :author => users[4])
m4 = Message.create!(:subject => "Titol del missatge", :body => "El meu avui se'n va anar a Cuba a bordo del Català", :user => users[2], :project => pj2, :author => users[4])
m5 = Message.create!(:subject => "¿Por que los de lepe ponen cebollas en la carretera?", :body => "- Por que son buenas para la circulación", :user => users[3], :project => pj2, :author => users[3])
m6 = Message.create!(:subject => "¿Por que los de lepe ponen cebollas en la carretera?", :body => "- Por que son buenas para la circulación", :user => users[2], :project => pj3, :author => users[2])
m7 = Message.create!(:subject => "Titol del missatge", :body => "El meu avui se'n va anar a Cuba a bordo del Català", :user => users[4], :project => pj3, :author => users[4])


puts "Creating some milestones"
Milestone.delete_all

5.times do |i|
  Milestone.create! :project => camaloon, :name => "Milestone #{i}", :finishes_at => Date.today + rand(5)
end

puts "Creating some task lists"

TaskList.delete_all
tl1 = TaskList.create!(:name => "Fer truita de patates", :project => pj2, :group => g_man)
tl2 = TaskList.create!(:name => "Fer lasagna d'espinacs", :project => pj1, :group => g_mark)
tl3 = TaskList.create!(:name => "Plantar l'hort", :project => pj3, :group => g_dis)
tl4 = TaskList.create!(:name => "Matança del porc", :project => pj3, :group => g_eng)

puts "Creating some tasks"

Task.delete_all
t1 = Task.create!(:author => roger, :task_list => tl1, :title => "Fregir patates", :description => "Posar a la paella i fregir les patates a foc lent però que quedin ben fetes i tal i qual.", :employee => bernat, :position => 1, :duration => 2.0)
t2 = Task.create!(:author => roger, :task_list => tl1, :title => "Batre els ous", :description => "Trencar els ous i posar-los en un bol. Agafar una forquilla i anar removent amb força i contundència fins que s'espesseixi lleugerament", :employee => dulce, :position => 2)
t3 = Task.create!(:author => roger, :task_list => tl1, :title => "Buscar recepta corresponent", :description => "Pillar el llibre corresponent", :employee => roger, :completed_at => Time.now, :position => 0, :duration => 1.0)
t4 = Task.create!(:author => roger, :task_list => tl1, :title => "Parlar amb personatge D", :description => "Anar i parlar amb l'home", :employee => sergi, :author => bernat, :completed_at => Time.now, :position => 0, :duration => 1.0)
t5 = Task.create!(:author => roger, :task_list => tl1, :title => "Parlar amb personatge C", :description => "Anar i parlar amb l'home", :employee => bernat, :completed_at => Time.now - 1.day, :position => 0, :duration => 1.0)
t6 = Task.create!(:author => roger, :task_list => tl1, :title => "Parlar amb personatge B", :description => "Anar i parlar amb l'home", :employee => roger, :author => bernat, :completed_at => Time.now - 2.day, :position => 0, :duration => 1.0)
t7 = Task.create!(:author => roger, :task_list => tl1, :title => "Parlar amb personatge A", :description => "Anar i parlar amb l'home", :employee => dulce, :author => bernat, :completed_at => Time.now - 3.day, :position => 0, :duration => 1.0)
t8 = Task.create!(:author => roger, :task_list => tl3, :title => "Sembrar tomàquets", :description => "Comprar llavors i plantar-les", :employee => bernat, :completed_at => Time.now - 5.day, :position => 0, :duration => 2.0)
t9 = Task.create!(:author => roger, :task_list => tl3, :title => "Sembrar cebes", :description => "Comprar germinats i plantar-los", :employee => bernat, :author => bernat, :completed_at => Time.now - 4.day, :position => 0, :duration => 3.0)
t10 = Task.create!(:author => roger, :task_list => tl3, :title => "Regar", :description => "Regar amb aigua abundant totes les plantes", :employee => dulce, :author => bernat, :completed_at => Time.now - 3.day, :position => 0, :duration => 2.0)
t11 = Task.create!(:author => roger, :task_list => tl4, :title => "Trobar porc", :description => "Comprar el porc a un pagès", :employee => roger, :author => bernat, :completed_at => Time.now - 2.day, :position => 0, :duration => 1.0)
t12 = Task.create!(:author => roger, :task_list => tl4, :title => "Executar porc", :description => "Executar el porc prenent precaucions higièniques i sanitàries", :employee => sergi, :completed_at => Time.now - 1.day, :position => 0, :duration => 3.0)

puts "Creating some comments"

puts "-- not yet implemented --"

puts "Creating some dummy events"

#For tasks
Event.delete_all
e1 = Event.create!(:event_type => "completed_task", :subject => t3, :context => pj2, :background => pj2, :actor => roger, :subdescrip => t3.title, :published => true)
e2 = Event.create!(:event_type => "completed_task", :subject => t4, :context => pj2, :background => pj2, :actor => sergi, :subdescrip => t4.title, :published => true)
e3 = Event.create!(:event_type => "completed_task", :subject => t5, :context => pj2, :background => pj2, :actor => bernat, :subdescrip => t5.title, :published => true)
e4 = Event.create!(:event_type => "completed_task", :subject => t6, :context => pj2, :background => pj2, :actor => roger, :subdescrip => t6.title, :published => true)
e5 = Event.create!(:event_type => "completed_task", :subject => t7, :context => pj2, :background => pj2, :actor => dulce, :subdescrip => t7.title, :published => true)
e6 = Event.create!(:event_type => "completed_task", :subject => t8, :context => pj3, :background => pj3, :actor => bernat, :subdescrip => t8.title, :published => true)
e7 = Event.create!(:event_type => "completed_task", :subject => t9, :context => pj3, :background => pj3, :actor => dulce, :subdescrip => t9.title, :published => true)

# For messages
e6 = Event.create!(:event_type => "new_message", :subject => m3, :context => pj2, :background => pj2, :actor => users[2], :subdescrip => m3.to_s, :published => true)
e7 = Event.create!(:event_type => "new_message", :subject => m4, :context => pj2, :background => pj2, :actor => users[4], :subdescrip => m4.to_s, :published => true)
e8 = Event.create!(:event_type => "new_message", :subject => m5, :context => pj2, :background => pj2, :actor => users[3], :subdescrip => m5.to_s, :published => true)
e9 = Event.create!(:event_type => "new_message", :subject => m6, :context => pj3, :background => pj3, :actor => users[2], :subdescrip => m6.to_s, :published => true)
e10 = Event.create!(:event_type => "new_message", :subject => m7, :context => pj3, :background => pj3, :actor => users[4], :subdescrip => m7.to_s, :published => true)
