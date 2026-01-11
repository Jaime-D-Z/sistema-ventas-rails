class CreateVenta < ActiveRecord::Migration[8.1]
  def change
    create_table :venta do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total
      t.datetime :fecha

      t.timestamps
    end
  end
end
