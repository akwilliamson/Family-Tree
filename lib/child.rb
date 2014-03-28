class Child < ActiveRecord::Base

  validates :parent1, :presence => true
  validates :parent2, :presence => true

  def self.list_children(input_object)
    children = Child.where((:parent1 => input_object.id OR :parent2 => input_object.id))
    children.each do |child|
      puts child.id.to_s + " #{child.name}"
    end
  end
end
