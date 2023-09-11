class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:create, :destroy]

  def create
    user = User.find_by(email: params[:email]) # Access email directly

    if user&.authenticate(params[:password]) # Access password directly
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { error: { login: "Invalid email or password" } }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { message: "Logged out successfully" }, status: :ok
  end
end
