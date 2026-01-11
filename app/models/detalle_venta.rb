class DetalleVenta < ApplicationRecord
  belongs_to :venta
  belongs_to :producto
  
  validates :cantidad, presence: true, numericality: { greater_than: 0 }
  validates :subtotal, presence: true, numericality: { greater_than: 0 }
end