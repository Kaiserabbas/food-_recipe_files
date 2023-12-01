class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  def index
    @current_user = current_user 
    @recipe_foods = RecipeFood.where(user_id: @current_user.id)
    @shopping_list = @recipe_foods.select { |rf| rf.quantity > rf.food.quantity }

    render 'index' # Make sure this view corresponds to the index action
  end


  def show
    return unless @user.nil? || @user == current_user
    redirect_to new_user_registration_path, notice: 'Signed out successfully'
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
      end
  end
  
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    if params[:id] == 'sign_out'
      # No need to find a user when signing out
      sign_out(current_user) if current_user
      @user = nil
    else
      @user = User.find(params[:id])
    end
  end

  # Only allow trusted parameters.
  def user_params
    params.require(:user).permit(:name)
  end
  
end
