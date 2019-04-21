class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit]
end
