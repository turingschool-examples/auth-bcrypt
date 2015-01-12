class UsersController < ApplicationController
  include ApplicationHelper
  
  def show
    @user = current_user
  end

end
