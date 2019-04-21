class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
     @uploads = current_user.uploads.all
  end
end
