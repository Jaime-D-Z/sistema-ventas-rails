# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_11_045619) do
  create_table "detalle_venta", force: :cascade do |t|
    t.integer "cantidad"
    t.datetime "created_at", null: false
    t.integer "producto_id", null: false
    t.decimal "subtotal"
    t.datetime "updated_at", null: false
    t.integer "venta_id", null: false
    t.index ["producto_id"], name: "index_detalle_venta_on_producto_id"
    t.index ["venta_id"], name: "index_detalle_venta_on_venta_id"
  end

  create_table "detalle_ventas", force: :cascade do |t|
    t.integer "cantidad"
    t.datetime "created_at", null: false
    t.integer "producto_id", null: false
    t.decimal "subtotal"
    t.datetime "updated_at", null: false
    t.integer "venta_id", null: false
    t.index ["producto_id"], name: "index_detalle_ventas_on_producto_id"
    t.index ["venta_id"], name: "index_detalle_ventas_on_venta_id"
  end

  create_table "productos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.string "nombre"
    t.decimal "precio"
    t.integer "stock"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fecha"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_venta_on_user_id"
  end

  create_table "ventas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fecha"
    t.decimal "total"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_ventas_on_user_id"
  end

  add_foreign_key "detalle_venta", "productos"
  add_foreign_key "detalle_venta", "venta", column: "venta_id"
  add_foreign_key "detalle_ventas", "productos"
  add_foreign_key "detalle_ventas", "venta", column: "venta_id"
  add_foreign_key "venta", "users"
  add_foreign_key "ventas", "users"
end
