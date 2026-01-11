class VentasController < ApplicationController
  before_action :authenticate_user!

  def index
    @ventas = current_user.ventas.order(fecha: :desc)
  end

  def new
    @venta = Venta.new
    @productos = Producto.where('stock > 0')
  end

  def create
    @venta = current_user.ventas.new
    
    total = 0
    productos_data = params[:productos] || {}
    
    # Validar que se hayan seleccionado productos
    if productos_data.values.all? { |v| v.to_i == 0 }
      @productos = Producto.where('stock > 0')
      flash.now[:alert] = 'Debes seleccionar al menos un producto con cantidad mayor a 0'
      render :new, status: :unprocessable_entity
      return
    end
    
    productos_data.each do |producto_id, cantidad|
      next if cantidad.to_i <= 0
      
      producto = Producto.find(producto_id)
      cantidad_int = cantidad.to_i
      
      if producto.stock >= cantidad_int
        subtotal = producto.precio * cantidad_int
        total += subtotal
        
        @venta.detalle_ventas.build(
          producto: producto,
          cantidad: cantidad_int,
          subtotal: subtotal
        )
        
        producto.update(stock: producto.stock - cantidad_int)
      end
    end
    
    @venta.total = total
    
    if @venta.save
      redirect_to ventas_path, notice: 'Venta registrada exitosamente.'
    else
      @productos = Producto.where('stock > 0')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @venta = current_user.ventas.find(params[:id])
  end

  private

  # Este método ya no es necesario, lo eliminamos
end