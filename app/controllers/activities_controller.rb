class ActivitiesController < ApplicationController
    before_action :authenticate_user
    before_action :set_activity, only: [:show, :update, :destroy]
    
    def index
      if current_user
        @activities = current_user.activities
        render json: @activities, status: :ok
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
    
 
    def show
      render json: @activity, status: :ok
    end
  
    def create
      @activity = current_user.activities.build(activity_params)
  
      if @activity.save
        render json: @activity, status: :created
      else
        render json: { errors: @activity.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @activity.update(activity_params)
        render json: @activity, status: :ok
      else
        render json: { errors: @activity.errors.full_messages }, status: :unprocessable_entity
      end
    end
  

    def destroy
      @activity.destroy
      head :no_content
    end
  
    private
  
    def set_activity
      @activity = current_user.activities.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Activity not found' }, status: :not_found
    end

    def authenticate_user
      unless session[:user_id]
        flash[:error] = 'You must be logged in to access this section'
        redirect_to authentication
      end
      
    end
  
    def activity_params
      params.permit(:name, :date, :description)
    end

  end
  