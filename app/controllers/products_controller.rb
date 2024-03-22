class ProductsController < ApplicationController

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you! 🤪"
    end

    @products = Product.includes(:store)
  end

end
