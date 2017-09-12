class SessionController < ApplicationController
  include SessionHelper
  def new
    #login page 
  end
  

  def create
    user = User.find_by(name: params[:session][:name].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to '/index'
    else
      flash.now[:danger] = "User Or Password Error"
      render 'new'
    end
  end
end
