class Person < ActiveRecord::Base

  validates :name, :presence => true
  after_save :make_marriage_reciprocal

  @@current_person = nil

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def self.list_all
    Person.all.sort.each do |person|
      puts person.id.to_s + ". " + person.name
    end
  end

  def self.choosing_person(name)
    person = Person.where(:name => name).first
    @@current_person = person
    self.current_person
  end

  def self.current_person
    @@current_person
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
