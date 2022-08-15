class UsersController < ApplicationController
    before_action :authorize, only: [:show] 
    
    # POST /signup
    def create 
        user = User.create(user_params)
        if user.valid?
        session[:user_id] = user.id 
        render json: user, status: :created
        else
            render json: {error: user.errors.full_messages}, status: :unprocessable_entity
        end
    end
    # create a new user
    # save their hashed password in the database
    # save the user's ID in the session hash
    # return the user object in the JSON response.

    # GET /me request
    def show
        user = User.find_by(id: session[:user_id])     
        render json: user       
    end
    # If the user is authenticated, return the user object in the JSON response.

    private

    def user_params
        params.permit(:username, :password, :password_confirmation) # password_digest gives us password_confirmation method
    end

    def authorize
        return render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id
    end
end
