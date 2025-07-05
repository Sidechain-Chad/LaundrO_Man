class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :confirmation, :tracking, :cancel, :confirm]
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
    @order = current_user.orders.build
    @order.laundromat = @laundromat

    item_params = order_params[:order_items_attributes]&.values || []
    total = 0

    item_params.each do |item|
      price_per_unit = price_for(item[:item_type])
      quantity = item[:quantity].to_i
      total += price_per_unit * quantity

      @order.order_items.build(
        item_type: item[:item_type],
        quantity: quantity,
        price: price_per_unit * quantity
      )
    end

    @order.total_price = total
    @order.status = "pending"

    if @order.save
      redirect_to confirmation_order_path(@order), notice: 'Order created!'
    else
      flash.now[:alert] = "Failed: #{@order.errors.full_messages.to_sentence}"
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation
    redirect_to @order, alert: 'Invalid order status' unless @order.status == "confirmed"
  end

  def confirm
    if current_user == @order.laundromat.owner && @order.status == "pending"
      @order.update(status: "confirmed")
      redirect_to @order, notice: "Order confirmed!"
    else
      redirect_to @order, alert: "Not authorized or already confirmed"
    end
  end

  def tracking
    @tracking_updates = @order.order_trackings.order(created_at: :desc)
  end

  def cancel
    if @order.may_cancel?
      @order.update(status: :cancelled)
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
        :_destroy
      ]
    )
  end

  def price_for(item_type)
    fixed_prices = {
      "Jeans" => 10,
      "Underwear" => 5,
      "Boxers" => 5,
      "Dress Pants" => 15,
      "Chinos" => 12,
      "Briefs" => 5,
      "Shorts" => 8,
      "Cargo Pants" => 14
    }
    fixed_prices[item_type] || 0
  end
end
