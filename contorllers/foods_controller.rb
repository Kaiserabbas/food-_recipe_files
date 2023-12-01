class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new
  end

  def create
    @food = current_user.foods.new(food_params)
    respond_to do |format|
      if @food.save
        format.html { redirect_to foods_path, notice: 'Food was created successfully' }
      else
        format.html do
          flash[:error] = @food.errors.full_messages.join(', ')
          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy

    if @food.destroy
      redirect_to foods_path, notice: 'Food was deleted successfully'
    else
      redirect_to foods_path, alert: 'There is an error deleting the food'
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :quantity, :price)
  end
end
