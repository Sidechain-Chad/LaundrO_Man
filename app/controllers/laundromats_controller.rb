class LaundromatsController < ApplicationController
  def index
    @laundromats = Laundromat.all
  end

  def show
    @laundromat = Laundromat.find(params[:id])
  end
end
