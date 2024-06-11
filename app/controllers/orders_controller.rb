class OrdersController<ApplicationController
  skip_forgery_protection
  before_action :authenticate!,:only_buyers!


  def index
    @orders = Order.where(buyer: current_user)
  end

  def create
    @order = Order.new(order_params) { |o| o.buyer = current_user }

    if @order.save
      render :create, status: :created
    else
      render json: {errors: @order.errors, status: :unprocessable_entity}
    end
  end

  def pay
    order = Order.find(params[:id])
    value = params[:value]
    number = params[:number]
    valid = params[:valid]
    cvv = params[:cvv]

    # Enfileira o job para ser executado posteriormente
    PaymentJob.perform_later(order: order, value: value, number: number, valid: valid, cvv: cvv)

    # Renderiza uma resposta ou redireciona conforme necessário
    render json: { status: 'Pagamento enfileirado com sucesso' }, status: :ok
  end

  private

  def order_params
    params.require(:order).permit([:store_id])
  end

end
