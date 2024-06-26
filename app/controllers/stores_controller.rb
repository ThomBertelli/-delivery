class StoresController < ApplicationController
  skip_forgery_protection
  before_action :set_store, only: %i[ show edit update destroy toggle_active upload_logo ]
  before_action :authenticate!
  include ActionController::Live

  # GET /stores or /stores.json
  def index
    respond_to do |format|
      format.json do
      page = params.fetch(:page,1)

        if current_user.admin?
          @stores = Store.page(page).all.includes(:logo_attachment)
        elsif current_user.buyer?
          @stores = Store.where(active: true,discarded_at: nil).page(page).includes(:logo_attachment)
        else
          @stores = Store.where(user: current_user, discarded_at: nil).page(page).includes(:logo_attachment)
        end

      end
    end
  end

  def toggle_active
    @store.update(active: !@store.active)
    render json: { success: true, active: @store.active }
  end

  # GET /stores/1 or /stores/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :show, status: :ok, location: @store }
    end
  end

  # GET /stores/new
  def new
    @store = Store.new
    if current_user.admin?
      @sellers = User.where(role: :seller)
    end
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)

    if !current_user.admin?
      @store.user = current_user
    end

    respond_to do |format|
      if @store.save
        format.html { redirect_to store_url(@store), notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to store_url(@store), notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    if @store.discard
      respond_to do |format|
        format.html { redirect_to stores_url, notice: 'Store was successfully deleted.' }
        format.json { render json: { message: 'Store deleted successfully' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to stores_url, alert: 'Store could not be deleted.' }
        format.json { render json: { error: 'Store could not be deleted' }, status: :unprocessable_entity }
      end
    end
  end

  def upload_logo
    if @store.update(logo_params)
      render json: { success: true, logo_url: url_for(@store.logo) }
    else
      render json: { success: false, errors: @store.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def new_order
    response.headers["Content-Type"] = "text/event-stream"
    sseVendy = SSE.new(response.stream, retry: 300, event: "waiting-orders")
    sseVendy.write({hello: "world!"}, event: "waiting-order")

    EventMachine.run do
      EventMachine::PeriodicTimer.new(3) do
        order = Order.includes(:order_items).where(store_id: params[:store_id], state: :paid).last
        if order
          message = {
          time: Time.now,
          order: order.as_json(
            include: {
              order_items: {
                include: {
                  product: {
                    only: [:title]
                  }
                }
              }
            }
          )}
          sseVendy.write(message, event: "new-order")
        else
          sseVendy.write(message, event: "no")
        end
      end
    end
  rescue IOError, ActionController::Live::ClientDisconnected
    sseVendy.close
  ensure
    sseVendy.close
  end

  def orders_history
    respond_to do |format|
      page = params.fetch(:page, 1)
      format.json do
        @orders = Order.includes(order_items: :product).where(store_id: params[:store_id]).where.not(order_items: { id: nil }).page(page)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      required = params.require(:store)
      if current_user.admin?
        required.permit(:name, :user_id)
      else
        required.permit(:name)
      end
    end

    def logo_params
      params.require(:store).permit(:logo)
    end
end
