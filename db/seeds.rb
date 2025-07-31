# Clear old data
Message.destroy_all
OrderItem.destroy_all
Order.destroy_all
Review.destroy_all
Laundromat.destroy_all
User.destroy_all

# === USERS ===

admin = User.create!(
  email: "admin@example.com",
  password: "password",
  first_name: "Alice",
  last_name: "Admin",
  address: Faker::Address.full_address,
  role: :admin
)

owners = 4.times.map do |i|
  User.create!(
    email: "owner#{i + 1}@example.com",
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: "Owner",
    address: "#{Faker::Address.street_address}, Cape Town",
    role: :owner
  )
end

customers = 10.times.map do |i|
  User.create!(
    email: "customer#{i+1}@example.com",
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: "#{Faker::Address.street_address}, Cape Town",
    role: :customer
  )
end

# === LAUNDROMATS ===
laundromats = owners.map do |owner|
  Laundromat.create!(
    name: Faker::Company.name,
    address: "#{Faker::Address.street_address}, Cape Town",
    phone_number: Faker::PhoneNumber.phone_number,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    user: owner
  )
end

# === ORDERS, ITEMS, MESSAGES, REVIEWS ===
statuses = Order.statuses.keys

20.times do
  customer = customers.sample
  laundromat = laundromats.sample

  order = Order.create!(
    user: customer,
    laundromat: laundromat,
    pickup_time: Faker::Time.forward(days: 2, period: :morning),
    delivery_time: Faker::Time.forward(days: 4, period: :evening),
    total_price: rand(50..300),
    status: statuses.sample
  )

  rand(1..3).times do
    OrderItem.create!(
      order: order,
      item_type: %w[Shirt Pants Jacket Blanket Towel].sample,
      quantity: rand(1..5),
      price: rand(30..100)
    )
  end

  Message.create!(
    user: customer,
    order: order,
    body: Faker::Lorem.question
  )

  Message.create!(
    user: laundromat.user,
    order: order,
    body: Faker::Lorem.sentence
  )

  if rand < 0.6
    Review.create!(
      user: customer,
      laundromat: laundromat,
      content: Faker::Lorem.sentence,
      rating: rand(3..5)
    )
  end
end

puts "✅ Seed complete: #{User.count} users, #{Laundromat.count} laundromats, #{Order.count} orders"
