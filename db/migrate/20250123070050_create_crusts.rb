class CreateCrusts < ActiveRecord::Migration[7.1]
  def change
    create_table :crusts do |t|
      t.string :name

      t.timestamps
    end
  end
end
