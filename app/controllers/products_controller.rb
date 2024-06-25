class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :set_product, only: [:show, :edit, :update, :destroy, :toggle_active, :upload_image]
  before_action :authenticate!
  before_action :set_locale!


  def show
    respond_to do |format|
      format.html
      format.json { render :show, status: :ok, location: @product }
    end
  end

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you! 🤪"
    end

    @products = Product.includes(:store)
  end

  def index
    order_by = params[:order] || 'title'
    respond_to do |format|
      format.json do
        if only_buyers!
          page = params.fetch(:page,1)
          @products = Product.
            where(store_id: params[:store_id],discarded_at: nil, active: true).
            page(page).
            includes(:image_attachment).
            order(order_by)
        elsif store_belongs_to_current_user?
          page = params.fetch(:page,1)
          @products = Product.
            where(store_id: params[:store_id],discarded_at: nil ).
            page(page).
            includes(:image_attachment).
            order(order_by)
        end
      end
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.discard
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_active
    @product.update(active: !@product.active)
    render json: { success: true, active: @product.active }
  end

  def upload_image
    if @product.update(image_params)
      render json: { success: true, image_url: url_for(@product.image) }
    else
      render json: { success: false, errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:store_id, :title, :price)
  end

  def store_belongs_to_current_user?
    @store = Store.find_by(id: params[:store_id])
    @store.user == current_user
  end

  def image_params
    params.require(:product).permit(:image)
  end

end
