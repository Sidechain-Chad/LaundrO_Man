class LaundromatsController < ApplicationController
  def index
    @laundromats = Laundromat.all
  end

  def show
    @laundromat = Laundromat.find(params[:id])
    @reviews = @laundromat.reviews.includes(:user)
    @review = Review.new
  end

  def new
    @laundromat = Laundromat.new
  end

  def create
    @laundromat = Laundromat.new(laundromat_params)
    @laundromat.user = current_user
    if @laundromat.save
      redirect_to laundromat_path(@laundromat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def laundromat_params
    params.require(:laundromat).permit(:name, :address, :phone_number, :photo)
  end
end
