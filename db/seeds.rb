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
require "open-uri"
require "faker"

puts "🧹 Cleaning database..."
Review.destroy_all
OrderTracking.destroy_all
OrderItem.destroy_all
Order.destroy_all
Laundromat.destroy_all
User.destroy_all

puts "👤 Creating admin..."
admin = User.create!(
  email: "admin@example.com",
  password: "password",
  first_name: "Admin",
  last_name: "User",
  address: "Admin HQ",
  role: :admin
)

puts "🧍 Creating laundromat owners and laundromats..."

owners_data = [
  {
    email: "owner1@example.com",
    first_name: "Liam",
    last_name: "Smith",
    address: "12 Fast Lane, Cape Town",
    phone_number: "021 123 4567",
    laundromat_name: "Quick Wash",
    image_url: "https://media.istockphoto.com/id/1346705134/photo/laundry-shop-interior-with-counter-and-washing-machines-3d-rendering.jpg?s=612x612&w=0&k=20&c=xJWp30P7LzfnFTWtXaCmhTRSxdowWITOKhqNlrM1hc0="
  },
  {
    email: "owner2@example.com",
    first_name: "Noah",
    last_name: "Brown",
    address: "99 Clean Ave, Durban",
    phone_number: "031 456 7890",
    laundromat_name: "Bubble & Shine",
    image_url: "https://media.istockphoto.com/id/1329022730/photo/stack-of-folded-towels-and-detergents-on-white-table-in-bathroom.jpg?s=612x612&w=0&k=20&c=hiH5LkPeRA7eb-AMVRRwww-idqKEkF3ruEfecW7vjto="
  },
  {
    email: "owner3@example.com",
    first_name: "Emma",
    last_name: "Jones",
    address: "88 Spin St, Joburg",
    phone_number: "011 987 6543",
    laundromat_name: "Spin City Laundry",
    image_url: "https://media.istockphoto.com/id/857747340/photo/water-splash-of-the-washing-machine-drum.jpg?s=612x612&w=0&k=20&c=gMM1GWjpnuWe28FhH5uyGJ6eTG53R93THOsBrIsZwD8="
  }
]

laundromats = []

owners_data.each do |data|
  owner = User.create!(
    email: data[:email],
    password: "password",
    first_name: data[:first_name],
    last_name: data[:last_name],
    address: data[:address],
    role: :owner
  )

  file = URI.open(data[:image_url])
  laundromat = Laundromat.create!(
    name: data[:laundromat_name],
    address: data[:address],
    phone_number: data[:phone_number],
    user: owner
  )
  laundromat.photos.attach(io: file, filename: "#{data[:laundromat_name].parameterize}.jpg", content_type: "image/jpeg")
  laundromats << laundromat
end

puts "🚗 Creating drivers..."

2.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.full_address,
    role: :driver
  )
end

puts "🧍 Creating customers..."

customers = []
2.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.full_address,
    role: :customer
  )
  customers << user
end

puts "📦 Creating orders, items, tracking and reviews..."

laundromats.each do |laundromat|
  customers.each do |customer|
    order = Order.create!(
      user: customer,
      laundromat: laundromat,
      pickup_time: Faker::Time.forward(days: 1, period: :morning),
      delivery_time: Faker::Time.forward(days: 2, period: :evening),
      status: "in_progress",
      total_price: 100.0
    )

    OrderItem.create!(
      order: order,
      item_type: "Shirt",
      quantity: 5,
      price: 50.0
    )

    OrderTracking.create!(
      order: order,
      status: "Picked up",
      notes: "Customer confirmed pickup."
    )

    Review.create!(
      user: customer,
      laundromat: laundromat,
      content: Faker::Restaurant.review
    )
  end
end

puts "✅ Seeding complete!"
