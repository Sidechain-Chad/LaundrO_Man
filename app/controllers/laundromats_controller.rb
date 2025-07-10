class LaundromatsController < ApplicationController
#  before_action :set_laundromat
  def index
    @laundromats = Laundromat.all
  end

  def show
    @laundromat = Laundromat.find(params[:id])
    @order = Order.new # for form
    @orders = @laundromat.orders.where(user: current_user)
    @message = Message.new
  end

  def create
    @laundromat = Laundromat.new(laundromat_params)
    @laundromat.user = current_user
  end

  private

    def set_laundromat
      @laundromat = Laundromat.find(params[:id])
    end
end
