class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :update]
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :check_password_params, only: [:update]
  before_action :set_user, only: [:show]

  def show
    @pagy, @rates = pagy(@user.rates
                              .ordered)
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: t("pages.confirmation.notices.check_email")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Tu cuenta fue eliminada"
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(update_user_params)
        if update_user_params[:unconfirmed_email].present?
          @user.send_confirmation_email!
          redirect_to root_path, notice: ""
        else
          redirect_to account_path, notice: t("pages.account.notices.data_updated")
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:error] = t("pages.account.alerts.wrong_current_password")
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  private

  def create_user_params
    params.require(:user).permit(:avatar, :name, :surname, :username, :phone, :birthdate, :gender, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:avatar, :name, :surname, :username, :phone, :birthdate, :gender, :password, :password_confirmation)
  end

  def check_password_params
    unless params[:user][:password].present? || params[:user][:password_confirmation].present?
      params[:user][:password] = params[:user][:current_password]
      params[:user].delete(:password_confirmation)
    end
  end

  def set_user
    @user = User.find_by(username: params[:username])
    unless @user
      if turbo_frame_request?
        flash[:alert] = t("pages.user.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, root_path)
      else
        redirect_to root_path, alert: t("pages.user.alerts.not_found")
      end
    end
  end
end
