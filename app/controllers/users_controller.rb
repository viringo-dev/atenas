class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :update]
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :check_password_params, only: [:update]

  def create
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: "i18n Revisa tu correo para la confirmación."
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
          redirect_to root_path, notice: "i18n Revisa tu correo para la confirmación."
        else
          redirect_to root_path, notice: "i18n Cuenta actualizada."
        end
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:error] = "i18n Contraseña incorrecta."
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  private

  def create_user_params
    params.require(:user).permit(:name, :surname, :username, :phone, :birthdate, :gender, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:name, :surname, :username, :phone, :birthdate, :gender, :password, :password_confirmation)
  end

  def check_password_params
    unless params[:user][:password].present? || params[:user][:password_confirmation].present?
      params[:user][:password] = params[:user][:current_password]
      params[:user].delete(:password_confirmation)
    end
  end
end
