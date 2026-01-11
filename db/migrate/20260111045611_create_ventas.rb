class CreateVentas < ActiveRecord::Migration[8.1]
  def change
    create_table :ventas do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total
      t.datetime :fecha

      t.timestamps
    end
  end
end
