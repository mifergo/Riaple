class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    if user = User.authenticate(params[:login], params[:password])
      session[:user_id] = user.id
      session[:name] = user.name + " " + user.surname
      # redirect_to admin_url
      redirect_to features_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:name] = nil
    redirect_to features_url, :notice => "Logged out"
  end

end
