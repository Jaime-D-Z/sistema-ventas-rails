class ProductosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_producto, only: [:show, :edit, :update, :destroy]

  def index
    @productos = Producto.all
  end

  def show
  end

  def new
    @producto = Producto.new
  end

  def create
    @producto = Producto.new(producto_params)
    
    respond_to do |format|
      if @producto.save
        format.html { redirect_to productos_path, notice: 'Producto creado exitosamente.' }
        format.json { render json: @producto, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @producto.update(producto_params)
      redirect_to productos_path, notice: 'Producto actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @producto.destroy
    redirect_to productos_path, notice: 'Producto eliminado exitosamente.'
  end

  private

  def set_producto
    @producto = Producto.find(params[:id])
  end

  def producto_params
    params.require(:producto).permit(:nombre, :precio, :stock, :descripcion)
  end
end