class UsersController < ApplicationController
  before_filter :authorize, only: [:show]

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end

end
