class ReviewsController < ApplicationController
  before_action :set_laundromat, only: %i[new create]

  def new
    @review = @laundromat.reviews.new
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.laundromat = @laundromat
    if @review.save
      redirect_to laundromat_path(@laundromat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_laundromat
    @laundromat = Laundromat.find(params[:laundromat_id])
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
