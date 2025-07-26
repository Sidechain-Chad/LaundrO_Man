class LaundromatsController < ApplicationController
  def index
    @laundromats = Laundromat.all
<<<<<<< HEAD
=======
    @markers = @laundromats.geocoded.map do |laundromat|
      {
        lat: laundromat.latitude,
        lng: laundromat.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { laundromat: laundromat }),
        marker_html: render_to_string(partial: "marker", locals: { laundromat: laundromat })
      }
    end

>>>>>>> 7d0b4326b40516846af396f1bcddf456edf185d3
    if params[:query].present?
      @laundromats = Laundromat.search_by_name_and_address(params[:query])
    end
  end

  def show
    @laundromat = Laundromat.find(params[:id])
    @reviews = @laundromat.reviews.includes(:user)
<<<<<<< HEAD
    @review = Review.new
    @order = Order.new
    @orders = @laundromat.orders.where(user: current_user)
    @message = Message.new
=======
    @review = @laundromat.reviews.new
>>>>>>> 7d0b4326b40516846af396f1bcddf456edf185d3
  end

  def new
    @laundromat = Laundromat.new
  end

  def create
    @laundromat = Laundromat.new(laundromat_params)
<<<<<<< HEAD
    @laundromat.save
    redirect_to laundromat_path(@laundromat)
=======
>>>>>>> 7d0b4326b40516846af396f1bcddf456edf185d3
    @laundromat.user = current_user
    if @laundromat.save
      redirect_to laundromat_path(@laundromat)
    else
      render :new, status: :unprocessable_entity
    end
<<<<<<< HEAD
=======
  end

  def destroy
    @laundromat = Laundromat.find(params[:id])
    @laundromat.destroy
    redirect_to laundromats_path, status: :see_other
>>>>>>> 7d0b4326b40516846af396f1bcddf456edf185d3
  end

  private

  def laundromat_params
    params.require(:laundromat).permit(:name, :address, :phone_number, photos: [])
  end
end
