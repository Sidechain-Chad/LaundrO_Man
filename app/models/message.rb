class Message < ApplicationRecord
  belongs_to :user
  belongs_to :order, dependent: :destroy
  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "order_#{order.id}_messages",
                        partial: "messages/message",
                        target: "messages",
                        locals: { message: self }
  end
end
