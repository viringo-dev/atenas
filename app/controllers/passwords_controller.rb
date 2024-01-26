class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated
  skip_before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        respond_to do |format|
          format.html { redirect_to root_path, notice: t("pages.password.notices.if_user_exists") }
          format.turbo_stream do
            flash[:notice] = t("pages.password.notices.if_user_exists")
            render turbo_stream: turbo_stream.action(:redirect, root_path)
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to new_confirmation_path, alert: t("pages.password.alerts.confirm_email") }
          format.turbo_stream do
            flash[:alert] = t("pages.password.alerts.confirm_email")
            render turbo_stream: turbo_stream.action(:redirect, new_confirmation_path)
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.password.notices.if_user_exists") }
        format.turbo_stream do
          flash[:notice] = t("pages.password.notices.if_user_exists")
          render turbo_stream: turbo_stream.action(:redirect, root_path)
        end
      end
    end
  end

  def edit
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, alert: t("pages.password.alerts.confirm_email")
    elsif @user.nil?
      redirect_to new_password_path, alert: t("pages.password.alerts.invalid_token_or_expired")
    end
  end

  def new
  end

  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: t("pages.password.alerts.confirm_email")
      elsif @user.update(password_params)
        @user.active_sessions.destroy_all
        reset_session
        redirect_to login_path, notice: t("pages.password.notices.password_updated")
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = t("pages.password.alerts.invalid_token_or_expired")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
