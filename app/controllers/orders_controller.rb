class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :confirmation, :tracking, :cancel]
  before_action :set_laundromat, only: [:new, :create]

  def index
    @orders = current_user.orders.includes(:laundromat, :order_items)
  end

  def show
  end

  def new
    @order = current_user.orders.build(laundromat: @laundromat)
    @order.order_items.build # Initialize at least one empty item
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.laundromat = @laundromat

    if @order.save
      @order.confirm! # Explicit confirmation if needed
      redirect_to confirmation_order_path(@order), notice: 'Order created!'
    else
      flash.now[:alert] = "Failed: #{@order.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation
    redirect_to @order, alert: 'Invalid order status' unless @order.confirmed?
  end

  def tracking
    @tracking_updates = @order.order_trackings.order(created_at: :desc)
  end

  def cancel
    if @order.may_cancel?
      @order.update(status: :cancelled) # Explicit status update
      redirect_to @order, notice: 'Order was successfully cancelled.'
    else
      redirect_to @order, alert: "Cannot cancel order in #{@order.status} state"
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_laundromat
    @laundromat = Laundromat.find(params[:laundromat_id])
  end

  def order_params
    params.require(:order).permit(
      :pickup_time,
      :delivery_time,
      order_items_attributes: [
        :id,
        :item_type,
        :quantity,
        :price,
        :_destroy
      ]
    )
  end
end
