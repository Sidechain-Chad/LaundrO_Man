class LaundromatsController < ApplicationController
  def index
    @laundromats = Laundromat.all
  end

  def show
    @laundromat = Laundromat.find(params[:id])
  end

  def new
    @laundromat = Laundromat.new
  end

  def create
    @laundromat = Laundromat.new(laundromat_params)
    @laundromat.save
    redirect_to laundromat_path(@laundromat)
  end

  private

  def laundromat_params
    params.require(:laundromat).permit(:name, :address, :phone_number)
  end
end
