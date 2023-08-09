class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  
  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "i18n Revisa tu correo para las instrucciones de confirmación."
    else
      redirect_to new_confirmation_path, alert: "i18n No encontramos un usuario con ese correo o el correo ya ha sido confirmado."
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present? && @user.unconfirmed?
      @user.confirm!
      login @user
      redirect_to root_path, notice: "i18n Tu cuenta ha sido confirmada."
    else
      redirect_to new_confirmation_path, alert: "i18n Token inválido."
    end
  end

  def new
    @user = User.new
  end
end
