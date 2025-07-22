class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :confirmation, :confirm, :cancel]
  before_action :set_laundromat, only: [:new, :create]

  # Shows a list of orders:
  # - Admins see all orders
  # - Other users see only their own
  def index
    scope = current_user.admin? ? Order : current_user.orders
    @orders = scope.includes(:laundromat, :order_items)
    if current_user.laundromat
      @bags = current_user.laundromat.orders
    else
      @bags = []
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
      @order.laundromat = @laundromat

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
      @laundromat = @order.laundromat

      unless can_view_order?(@order)
        redirect_to orders_path, alert: "You're not authorized to edit this order." and return
      end
    end

    def update
      if @order.update(order_params)
        total = calculate_total_price(@order.order_items)
        if @order.total_price != total
          @order.update_column(:total_price, total)
        end

        redirect_to confirmation_order_path(@order), notice: "Order updated!"
      else
        render :edit, alert: "Failed to update order."
      end
    end

    def show
      @message = Message.new
      @messages = @order.messages.includes(:user)
      return redirect_to orders_path, alert: "You are not authorized to view this order."
      unless can_view_order?(@order)

      @laundromat = @order.laundromat
      @order_items = @order.order_items
      @tracking_updates = @order.order_trackings.order(:created_at)
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

    # Finds the order based on the ID from the URL
    def set_order
      @order = Order.find(params[:id])
    end

    # Finds the laundromat for new or creating an order
    def set_laundromat
      @laundromat = Laundromat.find(params[:laundromat_id])
    end

    # Accepts only the allowed fields from the order form (strong params)
  def order_params
    params.require(:order).permit(
      :pickup_time,
      :delivery_time,
      order_items_attributes: [:id, :item_type, :quantity, :price, :_destroy]
    )
  end

    # Accepts only the delivery and pickup time fields when confirming an order
    def confirm_order_params
      params.require(:order).permit(:pickup_time, :delivery_time)
    end

    # Calculates the total cost by multiplying quantity × price for each item
    def calculate_total_price(order_items)
      order_items.map { |item| item.quantity.to_i * item.price.to_f }.sum
    end

    # Checks if the current user is allowed to view or manage the order
    def can_view_order?(order)
      current_user.admin? ||
        order.user == current_user ||
        order.laundromat.owner_id == current_user.id
    end
  end
