class LandingController < ApplicationController
  skip_before_action :authenticate_user!
  def new
  end

  def how_it_works
  end

  def terms_and_conditions
  end
end