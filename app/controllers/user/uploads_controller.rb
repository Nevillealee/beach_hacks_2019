class User::UploadsController < ApplicationController
  before_action :authenticate_user!

  def new
    @upload = Upload.new
  end

  def create
    @upload = current_user.uploads.create!(upload_params)
    redirect_to dashboard_path
  end

  private

  def upload_params
    params.require(:upload).permit(:title, :description, :file)
  end
end
