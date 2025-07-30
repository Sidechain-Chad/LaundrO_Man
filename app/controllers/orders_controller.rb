class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :confirmation, :confirm, :cancel]
  before_action :set_laundromat, only: [:new, :create]

  def index
    scope = current_user.admin? ? Order : current_user.orders
    @orders = scope.includes(:laundromat, :order_items)
    if current_user.laundromat
      @bags = current_user.laundromat.orders
    else
      @bags = []
    end
  end
    def new
      @order = @laundromat.orders.new
      @order.order_items.build
    end

    def create
      @order = @laundromat.orders.new(order_params)
      @order.user = current_user
      @order.set_default_status
      @order.total_price = calculate_total_price(@order.order_items)
      @order.laundromat = @laundromat

      if @order.save
        redirect_to confirmation_order_path(@order), notice: "Order created with status: #{@order.status}"
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
      @order.status = "pending"
      @message = Message.new
      @messages = @order.messages.includes(:user)
      unless can_view_order?(@order)
        return redirect_to orders_path, alert: "You are not authorized to view this order."
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

    def set_order
      @order = Order.find(params[:id])
    end

    def set_laundromat
      @laundromat = Laundromat.find(params[:laundromat_id])
    end

  def order_params
    params.require(:order).permit(
      :status,
      :pickup_time,
      :delivery_time,
      order_items_attributes: [:id, :item_type, :quantity, :price, :_destroy]
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
