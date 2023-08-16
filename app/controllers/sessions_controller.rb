class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.find_by(email: user_params[:email].downcase)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: t("pages.sign_in.alerts.unconfirmed")
      elsif @user.authenticate(user_params[:password])
        after_login_path = session[:user_return_to] || root_path
        active_session = login @user
        remember(active_session) if user_params[:remember_me] == "1"
        redirect_to after_login_path
      else
        flash.now[:alert] = t("pages.sign_in.alerts.invalid")
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = t("pages.sign_in.alerts.invalid")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_active_session
    logout
    redirect_to root_path
  end

  def new
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :remember_me)
  end
end
