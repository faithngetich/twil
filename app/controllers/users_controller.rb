class UsersController < Clearance::UsersController
  # GET /users/new
  def new
    @user = User.new
  end

   # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      authy = Authy::API.register_user(
        email: @user.email,
        country_code: @user.country_code,
        phone_number: @user.phone
      )
      @user.update(authy_id: authy.id)

      redirect_to root_path
    else
      render :new
    end

  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :phone, :country_code)
  end
end
