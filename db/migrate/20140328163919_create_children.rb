class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.column :name, :string
      t.column :parent1, :integer
      t.column :parent2, :integer
    end
  end
end
