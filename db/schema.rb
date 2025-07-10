# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

puts "🌱 Cleaning database..."
Message.delete_all
OrderTracking.delete_all
OrderItem.delete_all
Order.delete_all
Laundromat.delete_all
User.delete_all

puts "👤 Creating users..."
users = 3.times.map do |i|
  User.create!(
    email: "user#{i + 1}@example.com",
    encrypted_password: "password", # adjust if using Devise
    first_name: "User#{i + 1}",
    last_name: "Test",
    address: "123 Test Street #{i + 1}",
    role: 0 # assuming 0 = regular user
  )
end

owner = User.create!(
  email: "owner@example.com",
  encrypted_password: "password",
  first_name: "Owner",
  last_name: "Laundro",
  address: "456 Laundro Lane",
  role: 1 # assuming 1 = owner/admin
)

puts "🧺 Creating laundromats..."
laundromats = 2.times.map do |i|
  Laundromat.create!(
    name: "LaundroSpot #{i + 1}",
    address: "Area #{i + 1}",
    phone_number: "555-000#{i + 1}",
    owner_id: owner.id
  )
end

puts "📦 Creating orders..."
orders = 5.times.map do
  Order.create!(
    user: users.sample,
    laundromat: laundromats.sample,
    pickup_time: Time.now + rand(1..3).days,
    delivery_time: Time.now + rand(4..6).days,
    status: ["pending", "in_progress", "delivered"].sample,
    total_price: rand(50.0..150.0).round(2)
  )
end

puts "🧴 Adding order items..."
orders.each do |order|
  2.times do
    OrderItem.create!(
      order: order,
      item_type: ["Shirt", "Pants", "Blanket", "Towel"].sample,
      quantity: rand(1..5),
      price: rand(10.0..30.0).round(2)
    )
  end
end

puts "🚚 Adding order tracking info..."
orders.each do |order|
  OrderTracking.create!(
    order: order,
    status: ["picked_up", "washing", "ready", "delivered"].sample,
    notes: "Order update at #{Time.now}"
  )
end

puts "💬 Creating messages..."
orders.each do |order|
  Message.create!(
    content: "Question about order ##{order.id}",
    user: order.user,
    order: order
  )
end

puts "✅ Seeding complete!"
