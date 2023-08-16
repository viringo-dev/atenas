class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  
  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: t("pages.confirmation.notices.check_email")
    else
      redirect_to new_confirmation_path, alert: t("pages.confirmation.alerts.no_email_or_already_confirmed")
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present? && @user.unconfirmed?
      @user.confirm!
      login @user
      redirect_to root_path, notice: t("pages.confirmation.notices.confirmed")
    else
      redirect_to new_confirmation_path, alert: t("pages.confirmation.alerts.invalid_token")
    end
  end

  def new
    @user = User.new
  end
end
