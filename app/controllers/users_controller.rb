class UsersController < ApplicationController
  include ApplicationHelper

  def show
    @user = User.find(params[:id])
  end
end
