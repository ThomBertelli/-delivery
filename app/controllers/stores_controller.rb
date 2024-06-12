class StoresController < ApplicationController
  skip_forgery_protection
  before_action :set_store, only: %i[ show edit update destroy toggle_active upload_logo ]
  before_action :authenticate!

  # GET /stores or /stores.json
  def index
    if current_user.admin?
      @stores = Store.includes(logo_attachment: :blob).all
    elsif current_user.buyer?
      @stores = Store.includes(logo_attachment: :blob).where(active: true,discarded_at: nil)
    else
      @stores = Store.includes(logo_attachment: :blob).where(user: current_user, discarded_at: nil)
    end

    render json: @stores.map { |store|
    store.as_json.merge(logo_url: store.logo.attached? ? url_for(store.logo) : nil)
  }
  end

  def toggle_active
    @store.update(active: !@store.active)
    render json: { success: true, active: @store.active }
  end

  # GET /stores/1 or /stores/1.json
  def show
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
    sse = SSE.new(response.stream, retry: 300, event: "waiting-orders")
    sse.write({hello: "world!"}, event: "waiting-order")

    EventMachine.run do
      EventMachine::PeriodicTimer.new(3) do
        order = Order.where(store_id: params[:store_id], status: :created)
        if order
          message = { time: Time.now, order: order }
          sse.write(message, event: "new-order")
        else
          sse.write(message, event: "no")
        end
      end
    end
  rescue IOError, ActionController::Live::ClientDisconnected
    sse.close
  ensure
    sse.close
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
