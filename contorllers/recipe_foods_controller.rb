class RecipeFoodsController < ApplicationController
  def new
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @recipe_food = RecipeFood.new
  end

  def create
    puts "Recipe Food Params: #{recipe_food_params.inspect}"
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @food_ids = RecipeFood.where(recipe_id: @recipe.id).map(&:food_id)
    if @food_ids.include?(recipe_food_params[:food_id].to_i)
      return redirect_to recipe_path(@recipe.id), alert: 'Recipe already has this ingredient!'
    end

    @recipe_food = RecipeFood.new(recipe_food_params)
    @recipe_food.recipe_id = @recipe.id
    @recipe_food.user_id = current_user.id
    if @recipe_food.save
      flash[:notice] = 'Created successfully!'
    else
      flash[:alert] = 'Try again!'
      puts "Validation Errors: #{@recipe_food.errors.full_messages}"
    end
    redirect_to recipe_path(@recipe)
  end

  def edit
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @recipe_food = RecipeFood.includes(:recipe).find_by(id: params[:id])

    unless @recipe_food
      flash[:alert] = 'Record not found!'
      redirect_to recipe_path(@recipe) 
      return
    end
  end


  def update
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @recipe_food = RecipeFood.includes(:recipe).find_by(id: params[:id])
    if @recipe_food.update(recipe_food_params)
      flash[:notice] = 'Updated successfully!'
      redirect_to recipe_path(@recipe.id)
    else
      flash[:alert] = 'Try again!'
      redirect_to recipe_path(@recipe)
    end
  end

  def destroy
    @recipe_food = RecipeFood.includes(:recipe).find_by(id: params[:id])

    if @recipe_food
      if @recipe_food.destroy
        flash[:notice] = 'Deleted successfully!'
      else
        flash[:alert] = 'Try again!'
      end
    else
      flash[:alert] = 'Record not found in database!'
    end

    redirect_to recipe_path(id: params[:recipe_id])
  end

  private

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :food_id)
  end
end
