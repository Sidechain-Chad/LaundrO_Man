class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :cancel, :confirmation]
  before_action :set_laundromat, only: [:new, :create]

  def index
    @orders = current_user.orders
  end

  def show
  end

  def new
    @order = @laundromat.orders.new
    @order.order_items.build
  end

  def create
    @order = @laundromat.orders.new(order_params)
    @order.user = current_user
    @order.status = "pending"
    @order.total_price = calculate_total_price(@order.order_items)

    if @order.save
      redirect_to confirmation_order_path(@order)
    else
      render :new
    end
  end

  def cancel
    if @order.status == "pending"
      @order.update(status: "cancelled")
      redirect_to orders_path
    else
      redirect_to @order
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_laundromat
    @laundromat = Laundromat.find(params[:laundromat_id])
  end

  def order_params
    params.require(:order).permit(
      :pickup_time, :delivery_time,
      order_items_attributes: [:item_type, :quantity, :price]
    )
  end

  def calculate_total_price(order_items)
    order_items.map { |item| item.quantity.to_i * item.price.to_f }.sum
  end
end
