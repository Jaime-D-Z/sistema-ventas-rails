class HomeController < ApplicationController
  def index
  end
  
  def dashboard
    if user_signed_in?
      @total_productos = Producto.count
      @total_ventas = current_user.ventas.count
      @ventas_recientes = current_user.ventas.order(fecha: :desc).limit(5)
    else
      redirect_to root_path
    end
  end
end