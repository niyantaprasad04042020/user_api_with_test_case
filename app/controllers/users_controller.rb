class UsersController < ApplicationController
  protect_from_forgery with: :null_session
  
  def index
    @users = User.all
    respond_to do |format|
      if @users
        format.json { render json: @users.to_json }
      else
        format.json { render json: @users.errors }
      end
    end
  end

  def show
    @user = User.find_by(_id: user_params[:id])
    respond_to do |format|
      if @user
        format.json { render json: @user.to_json }
      else
        format.json { render json: @user.errors }
      end
    end
  end

  def create
    @user = User.create(first_name: user_params[:first_name], last_name: user_params[:last_name], email: user_params[:email])
    respond_to do |format|
      if @user.save
        format.json { render json: @user.to_json }
      else
        format.json { render json: { message: "User not creted" }, status: 422 }
      end
    end
  end

  def update
    @user = User.find_by(_id: params[:id]).update(user_params)
    respond_to do |format|
      if @user
        format.json { render json: @user.to_json }
      else
        format.json { render json: { message: "User not updated" }, status: 422 }
      end
    end
  end

  def destroy
    @user = User.delete_all(_id: user_params[:id])
  end

  def search
    @user = User.any_of({first_name: /#{params[:query]}/}, {last_name: /#{params[:query]}/}, {email: /#{params[:query]}/}).entries
    respond_to do |format|
      if @user
        format.json { render json: @user.to_json }
      else
        format.json { render json: { message: "User not found" }, status: 401 }
      end
    end
  end

  private

  def user_params
    params.permit(:id, :first_name, :last_name, :email)
  end

end
