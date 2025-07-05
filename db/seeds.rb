# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
require 'faker'
puts "Cleaning database..."
OrderItem.destroy_all
OrderTracking.destroy_all
Order.destroy_all
Laundromat.destroy_all
User.destroy_all

# Cape Town locations and names
CAPE_TOWN_AREAS = ["Gardens", "Sea Point", "Green Point", "Claremont", "Rondebosch", "Observatory", "Woodstock"]
SA_NAMES = ["Ndlovu", "Van der Merwe", "Smith", "Jacobs", "Petersen", "Khumalo", "Van Niekerk"]
SA_FIRST_NAMES = ["Lerato", "Thando", "Sipho", "Johannes", "Pieter", "Bongani", "Amina"]

# Clothing items focused on pants/jeans/underwear
CLOTHING_ITEMS = [
  { name: "Jeans", price: 25 },
  { name: "Dress Pants", price: 30 },
  { name: "Chinos", price: 22 },
  { name: "Underpants", price: 8 },
  { name: "Boxers", price: 10 },
  { name: "Briefs", price: 8 },
  { name: "Shorts", price: 18 },
  { name: "Cargo Pants", price: 28 }
]

# Create Users
puts "Creating users..."

# Admin
User.create!(
  email: "admin@example.com",
  password: "password",
  first_name: "Admin",
  last_name: "User",
  address: "12 Adderley St, Cape Town City Centre, 8001",
  role: :admin
)

# Owners (3)
owners = 3.times.map do |i|
  User.create!(
    email: "owner#{i+1}@example.com",
    password: "password",
    first_name: SA_FIRST_NAMES.sample,
    last_name: SA_NAMES.sample,
    address: "#{rand(1..100)} #{['Bree', 'Long', 'Loop'].sample} St, #{CAPE_TOWN_AREAS.sample}, 8000",
    role: :owner
  )
end

# Drivers (5)
# drivers = 5.times.map do |i|
#   User.create!(
#     email: "driver#{i+1}@example.com",
#     password: "password",
#     first_name: SA_FIRST_NAMES.sample,
#     last_name: SA_NAMES.sample,
#     address: "#{rand(1..100)} #{['Victoria', 'Albert'].sample} Rd, #{CAPE_TOWN_AREAS.sample}, 8000",
#     role: :driver
#   )
# end

# Customers (10)
customers = 10.times.map do |i|
  User.create!(
    email: "customer#{i+1}@example.com",
    password: "password",
    first_name: SA_FIRST_NAMES.sample,
    last_name: SA_NAMES.sample,
    address: "#{rand(1..100)} #{['Kloof', 'Buitenkant'].sample} St, #{CAPE_TOWN_AREAS.sample}, 8000",
    role: :customer
  )
end

# Create Laundromats
puts "Creating laundromats..."
laundromats = [
  "Cape Wash & Fold",
  "Table Mountain Laundry",
  "V&A Laundromat"
].map.with_index do |name, i|
  Laundromat.create!(
    name: name,
    address: "#{rand(1..100)} #{['Bree', 'Long'].sample} St, #{CAPE_TOWN_AREAS.sample}, 8000",
    phone_number: "+27 #{rand(60..89)} #{rand(100..999)} #{rand(1000..9999)}",
    # owner: owners.sample
  )
end

# Create Orders
puts "Creating orders..."
order_statuses = ["pending", "processing", "in_transit", "delivered"]

30.times do
  order = Order.create!(
    user: customers.sample,
    laundromat: laundromats.sample,
    pickup_time: Faker::Time.between(from: DateTime.now - 3, to: DateTime.now + 3),
    delivery_time: Faker::Time.between(from: DateTime.now + 4, to: DateTime.now + 7),
    status: order_statuses.sample,
    total_price: 0
  )

  # Add pants/jeans/underwear items
  order_total = 0
  rand(3..8).times do
    item = CLOTHING_ITEMS.sample
    quantity = rand(1..5)
    price = item[:price] * quantity
    order_total += price

    OrderItem.create!(
      order: order,
      item_type: item[:name],
      quantity: quantity,
      price: price
    )
  end

  order.update(total_price: order_total)

  # Create tracking
  status_index = order_statuses.index(order.status)
  order_statuses[0..status_index].each_with_index do |status, i|
    OrderTracking.create!(
      order: order,
      status: status,
      notes: "Status updated to #{status}",
      created_at: order.created_at + i.hours
    )
  end
end

# Assign drivers to in-progress orders
# puts "Assigning drivers..."
# Order.where(status: ["processing", "in_transit"]).each do |order|
#   order.update(driver_id: drivers.sample.id)
# end

puts "Seeding complete! Created:"
puts "- #{User.count} users"
puts "- #{Laundromat.count} laundromats"
puts "- #{Order.count} orders"
puts "- #{OrderItem.count} clothing items"
