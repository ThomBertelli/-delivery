class RegistrationsController<ApplicationController
  skip_forgery_protection only: [:create, :me, :sign_in]
  before_action :authenticate!, only: [:me]
  rescue_from User::InvalidToken, with: :not_authorized

  def me
    render json: {
      id: current_user[:id], email: current_user[:email]
    }
  end


  def sign_in
    access = current_credential.access
    user = User.where(role:access).find_by(email: sign_in_params[:email])

    if !user || !user.valid_password?(sign_in_params[:password])
      render json: {message: "Nope!"}, status: 401
    else
      token = User.token_for(user)
      render json: {email: user.email, token: token}
    end


  end
  def create
    @user = User.new(user_params)
    @user.role = current_credential.access

    if @user.save
      render json: {"email": @user.email}
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    unless current_credential.user == @user
      return render json: { message: "Unauthorized" }, status: :unauthorized
    end

    if @user.valid_password?(update_params[:current_password])
      if @user.update(email: update_params[:email], password: update_params[:password])
        render json: { message: "User information updated successfully." }, status: :ok
      else
        render json: { message: "Unable to update user information.", errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Current password is incorrect." }, status: :unauthorized
    end
  end

  private

  def update_params
    params.require(:user).permit(:email, :password, :current_password)
  end

  def user_params
    params
      .required(:user)
      .permit(:email, :password, :password_confirmation)
  end

  def sign_in_params
    params
      .required(:login)
      .permit(:email, :password)
  end

  def not_authorized(e)
    render json: {message: "Nope!"}, status: 401
  end




end
