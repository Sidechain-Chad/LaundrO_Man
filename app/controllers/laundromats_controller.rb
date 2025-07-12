class LaundromatsController < ApplicationController
  def index
    @laundromats = Laundromat.all
  end

  def show
    @laundromat = Laundromat.find(params[:id])
    @reviews = @laundromat.reviews.includes(:user)
    @review = Review.new
    @order = Order.new # for form
    @orders = @laundromat.orders.where(user: current_user)
    @message = Message.new
  end

  def new
    @laundromat = Laundromat.new
  end

  def create
    @laundromat = Laundromat.new(laundromat_params)
    @laundromat.save
    redirect_to laundromat_path(@laundromat)
    @laundromat.user = current_user
  end

  private

  def laundromat_params
    params.require(:laundromat).permit(:name, :address, :phone_number)
  end
end
