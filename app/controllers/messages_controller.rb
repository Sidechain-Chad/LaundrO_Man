class MessagesController < ApplicationController

  def show
  end
  def create
    @order = Order.find(params[:order_id])
    @message = Message.new(message_params)
    @message.order = @order
    @message.user = current_user
      if @message.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.append(:messages, partial: "messages/message",
              locals: { message: @message, user: current_user })
          end
          format.html { redirect_to order_path(@order) }
        end
      else
        render "orders/show", status: :unprocessable_entity
      end

  end

  def broadcast_message
    broadcast_append_to "booking_#{booking.id}_messages",
                        partial: "messages/message",
                        locals: { message: self, user: user },
                        target: "messages"
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
