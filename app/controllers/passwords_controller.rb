class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, notice: "i18n Si el usuario existe, enviaremos las instrucciones a su correo."
      else
        redirect_to new_confirmation_path, alert: "Por favor confirmar tu correo primero."
      end
    else
      redirect_to root_path, notice: "i18n Si el usuario existe, enviaremos las instrucciones a su correo."
    end
  end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, alert: "i18n Tienes que confirmar tu correo antes de iniciar sesión."
    elsif @user.nil?
      redirect_to new_password_path, alert: "i18n Token inválido o expirado."
    end
  end

  def new
  end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "i18n Tienes que confirmar tu correo antes de iniciar sesión."
      elsif @user.update(password_params)
        @user.active_sessions.destroy_all
        reset_session
        redirect_to login_path, notice: "i18n Iniciar sesión."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "i18n Token inválido o expirado."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
