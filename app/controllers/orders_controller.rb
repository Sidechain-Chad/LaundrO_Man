class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :confirmation, :confirm, :cancel]
  before_action :set_laundromat, only: [:new, :create]

  def index
    scope = current_user.admin? ? Order : current_user.orders
    @orders = scope.includes(:laundromat, :order_items)
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
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation
    unless can_view_order?(@order)
      return redirect_to orders_path, alert: "You can't confirm this order."
    end

    @laundromat = @order.laundromat
    @order_items = @order.order_items
  end

  def confirm
    unless can_view_order?(@order)
      return redirect_to orders_path, alert: "You can't confirm this order."
    end

    if @order.update(confirm_order_params.merge(status: "pending"))
      @order.update(total_price: calculate_total_price(@order.order_items))
      redirect_to orders_path, notice: "Order Processed!"
    else
      redirect_to confirmation_order_path(@order), alert: "Failed to confirm order."
    end
  end

  def edit
    unless can_view_order?(@order)
      redirect_to orders_path, alert: "You're not authorized to edit this order."
    end
    @laundromat = @order.laundromat
  end

  def update
    if @order.update(order_params)
      @order.update(total_price: calculate_total_price(@order.order_items))
      redirect_to confirmation_order_path(@order), notice: "Order updated!"
    else
      render :edit, alert: "Failed to update order."
    end
  end

  def show
    return redirect_to orders_path, alert: "You are not authorized to view this order." unless can_view_order?(@order)

    @laundromat = @order.laundromat
    @order_items = @order.order_items
    @tracking_updates = @order.order_trackings.order(:created_at)
  end

  def cancel
    if @order.status == "pending"
      @order.update(status: "pending")
      redirect_to orders_path, notice: "Order cancelled."
    else
      redirect_to @order, alert: "Only pending orders can be cancelled."
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
      :pickup_time,
      :delivery_time,
      :laundromat_id,
      order_items_attributes: [:item_type, :quantity, :price]
    )
  end

  def confirm_order_params
    params.require(:order).permit(:pickup_time, :delivery_time)
  end

  def calculate_total_price(order_items)
    order_items.map { |item| item.quantity.to_i * item.price.to_f }.sum
  end

  def can_view_order?(order)
    current_user.admin? ||
      order.user == current_user ||
      order.laundromat.owner_id == current_user.id ||
      order.driver_id == current_user.id
  end
end
