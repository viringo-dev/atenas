class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :destroy, :update]
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :set_user, only: [:show]

  def show
    @pagy, @ratings = pagy(@user.ratings
                                .ordered)
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.confirmation.notices.check_email") }
        format.turbo_stream do
          flash[:notice] = t("pages.confirmation.notices.check_email")
          render turbo_stream: turbo_stream.action(:redirect, root_path)
        end
      end
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
  end

  def new
    @user = User.new
  end

  private

  def create_user_params
    params.require(:user).permit(:avatar, :name, :surname, :slug, :phone, :birthdate, :gender, :email, :password, :password_confirmation, :rgpd_accepted)
  end

  def update_user_params
    params.require(:user).permit(:avatar, :name, :surname, :slug, :phone, :birthdate, :gender, :password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(slug: params[:slug])
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
