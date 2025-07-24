class LaundromatsController < ApplicationController
  def index
    @laundromats = Laundromat.all
    @markers = @laundromats.geocoded.map do |laundromat|
      {
        lat: laundromat.latitude,
        lng: laundromat.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { laundromat: laundromat }),
        marker_html: render_to_string(partial: "marker", locals: { laundromat: laundromat })
      }
    end

    if params[:query].present?
      @laundromats = Laundromat.search_by_name_and_address(params[:query])
    end
  end

  def show
    @laundromat = Laundromat.find(params[:id])
    @reviews = @laundromat.reviews.includes(:user)
    @review = @laundromat.reviews.new
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

  def destroy
    @laundromat = Laundromat.find(params[:id])
    @laundromat.destroy
    redirect_to laundromats_path, status: :see_other
  end

  private

  def laundromat_params
    params.require(:laundromat).permit(:name, :address, :phone_number, photos: [])
  end
end
