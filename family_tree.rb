require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

require 'pry'

def menu
  puts "***************************"
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'
  puts "***************************\n"

  loop do
    puts "Press 'a' to add a family member."
    puts "Press 'l' to list people."
    puts "Type 'e' to edit a person's family relations."
    puts "Press 'x' to exit."
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list
    when 'e'
      search_person
    when 'x'
      exit
    end
  end
end

def list
  puts "Here are all your relatives:\n"
  Person.list_all
  puts "\n"
  puts "Select the name of a person to view their relatives"
  name = gets.chomp.capitalize
  people_person = Person.choosing_person(name)
  spouse = Person.where(:id => people_person.spouse_id).first
  puts "Spouse: #{spouse.name}"
  child_person = Child.where(:name => name).first
  if child_person == nil
    puts "This family tree starts with #{people_person.name}."
  else
    parent_1 = Person.where(:id => child_person.parent1).first
    parent_2 = Person.where(:id => child_person.parent2).first
    puts "Parents: #{parent_1.name} and #{parent_2.name}"
  end
  Child.list_children(people_person)
end

def search_person
  Person.list_all
  puts "Enter the person's name:"
  name = gets.chomp.capitalize
  person = Person.choosing_person(name)
  puts "\n#{person.name} has been found."
  puts "\n\n"
  puts "What would you like to do to #{person.name}?"
  puts "Press 's' to add a spouse to #{person.name}"
  puts "Press 'p' to add parents to #{person.name}"
  puts "Press 'c' to add a child to #{person.name}"
  puts "Press 'm' to go back to the Main Menu"

  choice = gets.chomp

  case choice
  when 's'
    add_spouse
  when 'p'
    add_parent
  when 'c'
    add_child
  when 'm'
    menu
  end
end
def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end



def add_spouse
  person = Person.current_person
  Person.list_all
  puts "\nEnter the name of #{person.name}'s spouse?"
  spouse_name = gets.chomp
  persons_spouse = Person.where(:name => spouse_name).first
  person.update(:spouse_id => persons_spouse.id)
  puts person.name + " is now married to " + persons_spouse.name + "."
end


def show_marriage
  Person.list_all
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

def add_child
  parent1 = Person.current_person
  Person.list_all
  puts "Enter #{parent1.name}'s child's name."
  name_input = gets.chomp
  child = Person.where(:name => name_input).first
  puts "What is the name of #{child.name}'s second parent?"
  parent2_name = gets.chomp
  parent2 = Person.where(:name => parent2_name).first
  Child.create(:name => child.name, :parent1 => parent1.id, :parent2 => parent2.id)
  puts "#{child.name} is now the child of #{parent1.name} and #{parent2.name}\n"
end



menu
