class OrdersController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_order, only: [:show, :confirmation, :tracking, :cancel, :confirm]
  before_action :set_laundromat, only: [:new, :create]

  def index
    @orders = current_user.orders.includes(:laundromat, :order_items)
    if current_user.laundromat
      @bags = current_user.laundromat.orders
    else
      @bags = []
    end
  end

  def show
    @order = Order.find(params[:id])
    @message = Message.new
    return redirect_to orders_path, alert: "You are not authorized to view this order." unless can_view_order?(@order)

    @laundromat = @order.laundromat
    @order_items = @order.order_items
    @tracking_updates = @order.order_trackings.order(:created_at)
  end

  def new
    @order = current_user.orders.build(laundromat: @laundromat)
    @order.order_items.build # Initialize at least one empty item

  end

  def create
      session[:pending_order] = order_params.to_h.except("pickup_time", "delivery_time")
      redirect_to confirmation_orders_path
  end


  def confirmation

    data = session[:pending_order]
    return redirect_to root_path, alert: "No pending order found." unless data


    @order = Order.new(data)
    @order.user = current_user


    @laundromat = Laundromat.find_by(id: data["laundromat_id"])


    @order.total_price = calculate_total_price(@order.order_items)
  end

  def confirm
    order_data = session.delete(:pending_order)
    return redirect_to root_path, alert: "No pending order." unless order_data

    @order = Order.new(order_data)
    @order.user = current_user
    @order.status = "pending"
    @order.assign_attributes(confirm_order_params)

    @order.total_price = calculate_total_price(@order.order_items)

    if @order.save
      redirect_to order_path(@order), notice: "Order confirmed!"
    else
      redirect_to confirmation_orders_path, alert: "Failed to confirm order."
    end
  end


  def cancel
    if @order.status == "pending"
      @order.update(status: "cancelled")
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
      order.laundromat.user_id == current_user.id
  end
end
