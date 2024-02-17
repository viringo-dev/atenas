class ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  skip_before_action :authenticate_user!, only: [:new, :create, :edit]
  
  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.confirmation.notices.check_email") }
        format.turbo_stream do
          flash[:notice] = t("pages.confirmation.notices.check_email")
          render turbo_stream: turbo_stream.action(:redirect, root_path)
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_confirmation_path, alert: t("pages.confirmation.alerts.no_email_or_already_confirmed") }
        format.turbo_stream do
          flash[:alert] = t("pages.confirmation.alerts.no_email_or_already_confirmed")
          render turbo_stream: turbo_stream.action(:redirect, new_confirmation_path)
        end
      end
    end
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present? && @user.unconfirmed?
      @user.confirm!
      login @user
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.confirmation.notices.confirmed") }
        format.turbo_stream do
          flash[:notice] = t("pages.confirmation.notices.confirmed")
          render turbo_stream: turbo_stream.action(:redirect, root_path)
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_confirmation_path, alert: t("pages.confirmation.alerts.invalid_token") }
        format.turbo_stream do
          flash[:alert] = t("pages.confirmation.alerts.invalid_token")
          render turbo_stream: turbo_stream.action(:redirect, new_confirmation_path)
        end
      end
    end
  end

  def new
    @user = User.new
  end
end
