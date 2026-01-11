class Venta < ApplicationRecord
  belongs_to :user
  has_many :detalle_ventas, dependent: :destroy
  has_many :productos, through: :detalle_ventas
  
  validates :total, presence: true, numericality: { greater_than: 0 }
  
  before_create :set_fecha
  
  private
  
  def set_fecha
    self.fecha = DateTime.now
  end
end