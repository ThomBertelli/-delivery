class ProductsController < ApplicationController
  before_action :authenticate!
  before_action :set_locale!


  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you! 🤪"
    end

    @products = Product.includes(:store)
  end

  def index
    respond_to do |format|
      format.json do
        if only_buyers!
          page = params.fetch(:page,1)
          @products = Product.
            where(store_id: params[:store_id]).
            order(:title)
            page(page)
        end
      end
    end
  end

end
