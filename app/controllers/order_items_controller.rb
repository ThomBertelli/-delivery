class OrderItemsController < ApplicationController
  skip_forgery_protection
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  # GET /order_items
  def index
    @order_items = OrderItem.all

    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @order_items }
    end
  end

  # GET /order_items/1
  def show
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: @order_item }
    end
  end

  # GET /order_items/new
  def new
    @order_item = OrderItem.new

    respond_to do |format|
      format.html # renders new.html.erb
      format.json { render json: @order_item }
    end
  end

  # GET /order_items/1/edit
  def edit
    respond_to do |format|
      format.html # renders edit.html.erb
      format.json { render json: @order_item }
    end
  end

  # POST /order_items
  def create
    @order_item = OrderItem.new(order_item_params)

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @order_item, notice: 'Order item was successfully created.' }
        format.json { render :create, status: :created, location: @order_item }
      else
        format.html { render :new }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_items/1
  def update
    respond_to do |format|
      if @order_item.update(order_item_params)
        format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_item }
      else
        format.html { render :edit }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_items/1
  def destroy
    @order_item.destroy
    respond_to do |format|
      format.html { redirect_to order_items_url, notice: 'Order item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :amount, :price)
  end


end
