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
puts ":broom: Cleaning database..."
Review.destroy_all
OrderTracking.destroy_all
OrderItem.destroy_all
Order.destroy_all
Laundromat.destroy_all
User.destroy_all
# -----------------------------------
puts ":wrench: Constants setup..."
CAPE_TOWN_AREAS = ["Gardens", "Sea Point", "Green Point", "Claremont", "Rondebosch", "Observatory", "Woodstock"]
SA_NAMES = ["Ndlovu", "Van der Merwe", "Smith", "Jacobs", "Petersen", "Khumalo", "Van Niekerk"]
SA_FIRST_NAMES = ["Lerato", "Thando", "Sipho", "Johannes", "Pieter", "Bongani", "Amina"]
CLOTHING_ITEMS = [
  { name: "T-Shirt", price: 25 },
  { name: "Shirt", price: 28 },
  { name: "Blouse", price: 32 },
  { name: "Polo Shirt", price: 26 },
  { name: "Chinos", price: 38 },
  { name: "Dress Pants", price: 45 },
  { name: "Jeans", price: 40 },
  { name: "Shorts", price: 30 },
  { name: "Jacket", price: 65 },
  { name: "Hoodie", price: 60 },
  { name: "Sweater", price: 55 },
  { name: "Tracksuit", price: 70 },
  { name: "Underpants", price: 12 },
  { name: "Boxers", price: 14 },
  { name: "Briefs", price: 12 },
  { name: "Bra", price: 15 },
  { name: "Socks (Pair)", price: 8 },
  { name: "Undershirt", price: 15 },
  { name: "Silk Blouse", price: 45 },
  { name: "Lace Dress", price: 60 },
  { name: "Wool Sweater", price: 50 },
  { name: "Scarf", price: 18 },
  { name: "Suit (2-piece)", price: 130 },
  { name: "Suit (3-piece)", price: 150 },
  { name: "Evening Gown", price: 170 },
  { name: "Coat", price: 95 },
  { name: "Blazer", price: 70 },
  { name: "Skirt", price: 45 },
  { name: "Dress", price: 55 },
  { name: "Curtains", price: 65 },
  { name: "Bed Sheet", price: 40 },
  { name: "Duvet Cover", price: 60 },
  { name: "Pillow Case", price: 18 },
  { name: "Blanket", price: 75 },
  { name: "Comforter", price: 90 },
  { name: "Mattress Cover", price: 85 },
  { name: "Tablecloth", price: 35 },
  { name: "Rug (Small)", price: 110 },
  { name: "Rug (Large)", price: 180 }
]
# -----------------------------------
puts ":bust_in_silhouette: Creating admin..."
User.create_with(
  password: "password",
  first_name: "Admin",
  last_name: "User",
  address: "Admin HQ",
  role: :admin
).find_or_create_by!(email: "admin@example.com")
# -----------------------------------
puts ":standing_person: Creating laundromat owners..."
owners_data = [
  {
    email: "owner1@example.com",
    first_name: "Liam",
    last_name: "Smith",
    address: "12 Fast Lane, Cape Town",
    laundromat_name: "Quick Wash",
    phone_number: "021 123 4567",
    image_url: "https://media.istockphoto.com/id/1346705134/photo/laundry-shop-interior-with-counter-and-washing-machines-3d-rendering.jpg?s=612x612&w=0&k=20&c=xJWp30P7LzfnFTWtXaCmhTRSxdowWITOKhqNlrM1hc0="
  },
  {
    email: "owner2@example.com",
    first_name: "Noah",
    last_name: "Brown",
    address: "Salt River, Cape Town",
    laundromat_name: "Bubble & Shine",
    phone_number: "031 456 7890",
    image_url: "https://media.istockphoto.com/id/1329022730/photo/stack-of-folded-towels-and-detergents-on-white-table-in-bathroom.jpg?s=612x612&w=0&k=20&c=hiH5LkPeRA7eb-AMVRRwww-idqKEkF3ruEfecW7vjto="
  },
  {
    email: "owner3@example.com",
    first_name: "Emma",
    last_name: "Jones",
    address: "88 Spin St, Joburg",
    laundromat_name: "Spin City Laundry",
    phone_number: "011 987 6543",
    image_url: "https://media.istockphoto.com/id/857747340/photo/water-splash-of-the-washing-machine-drum.jpg?s=612x612&w=0&k=20&c=gMM1GWjpnuWe28FhH5uyGJ6eTG53R93THOsBrIsZwD8="
  },
  # New Cape Town laundromats with real addresses
  {
    email: "drwash@example.com",
    first_name: "Amina",
    last_name: "Khumalo",
    address: "40 Cole Street, Observatory, Cape Town, 7925",
    laundromat_name: "Dr Wash Laundry",
    phone_number: "021 447 1313",
    image_url: "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  },
  {
    email: "ilovemylaundry@example.com",
    first_name: "Sipho",
    last_name: "Ndlovu",
    address: "59 Buitengracht Street, Cape Town, 8001",
    laundromat_name: "I Love My Laundry",
    phone_number: "021 422 3456",
    image_url: "https://plus.unsplash.com/premium_photo-1678218568883-1c2482ccdac3?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  },
  {
    email: "coinop@example.com",
    first_name: "Lerato",
    last_name: "Petersen",
    address: "16 Cobern Street, Green Point, Cape Town, 8005",
    laundromat_name: "CoinOp Laundromat",
    phone_number: "021 425 4251",
    image_url: "https://media.istockphoto.com/id/1346705134/photo/laundry-shop-interior-with-counter-and-washing-machines-3d-rendering.jpg?s=612x612&w=0&k=20&c=xJWp30P7LzfnFTWtXaCmhTRSxdowWITOKhqNlrM1hc0="
  },
  {
    email: "thelaunderers.camps@example.com",
    first_name: "Johannes",
    last_name: "Van der Merwe",
    address: "87 Victoria Road, Camps Bay, Cape Town, 8005",
    laundromat_name: "The Launderers - Camps Bay",
    phone_number: "084 443 9786",
    image_url: "https://media.istockphoto.com/id/1329022730/photo/stack-of-folded-towels-and-detergents-on-white-table-in-bathroom.jpg?s=612x612&w=0&k=20&c=hiH5LkPeRA7eb-AMVRRwww-idqKEkF3ruEfecW7vjto="
  },
  {
    email: "thelaunderers.gardens@example.com",
    first_name: "Thando",
    last_name: "Jacobs",
    address: "50 Kloof Road, Gardens, Cape Town, 8001",
    laundromat_name: "The Launderers - Gardens",
    phone_number: "084 443 9786",
    image_url: "https://media.istockphoto.com/id/857747340/photo/water-splash-of-the-washing-machine-drum.jpg?s=612x612&w=0&k=20&c=gMM1GWjpnuWe28FhH5uyGJ6eTG53R93THOsBrIsZwD8="
  },
  {
    email: "rondewash@example.com",
    first_name: "Pieter",
    last_name: "Van Niekerk",
    address: "Main Road, Rondebosch, Cape Town, 7700",
    laundromat_name: "Rondewash Laundry",
    phone_number: "021 689 1234",
    image_url: "https://media.istockphoto.com/id/1386479313/photo/laundromat-washing-machines-in-a-row.jpg?s=612x612&w=0&k=20&c=myEi6jQZjVMGRz5ZQgJnfpHjKhOqN9ubnmqgKkNxB1I="
  },
  {
    email: "galleria@example.com",
    first_name: "Bongani",
    last_name: "Smith",
    address: "40 Bromwell Street, Woodstock, Cape Town, 7925",
    laundromat_name: "Galleria Laundry Services",
    phone_number: "021 447 3102",
    image_url: "https://media.istockphoto.com/id/1419491563/photo/clean-folded-clothes-stacked-in-laundry-basket.jpg?s=612x612&w=0&k=20&c=HrF5M_-LPKrjNV7KJVdnhgqCLF7nwE6jKE7fV4uGtK8="
  },
  {
    email: "mybeautiful.seapoint@example.com",
    first_name: "Lerato",
    last_name: "Brown",
    address: "Corner Rocklands & Main Road, Sea Point, Cape Town, 8005",
    laundromat_name: "My Beautiful Laundry - Sea Point",
    phone_number: "073 430 9468",
    image_url: "https://media.istockphoto.com/id/1346705134/photo/laundry-shop-interior-with-counter-and-washing-machines-3d-rendering.jpg?s=612x612&w=0&k=20&c=xJWp30P7LzfnFTWtXaCmhTRSxdowWITOKhqNlrM1hc0="
  },
  {
    email: "mybeautiful.woodstock@example.com",
    first_name: "Sipho",
    last_name: "Jones",
    address: "105 Sir Lowry Road, Woodstock, Cape Town, 7925",
    laundromat_name: "My Beautiful Laundry - Woodstock",
    phone_number: "063 262 1469",
    image_url: "https://media.istockphoto.com/id/1329022730/photo/stack-of-folded-towels-and-detergents-on-white-table-in-bathroom.jpg?s=612x612&w=0&k=20&c=hiH5LkPeRA7eb-AMVRRwww-idqKEkF3ruEfecW7vjto="
  },
  {
    email: "clares@example.com",
    first_name: "Amina",
    last_name: "Van der Merwe",
    address: "Cavendish Street, Claremont, Cape Town, 7708",
    laundromat_name: "Clare's Laundry Services",
    phone_number: "021 674 5678",
    image_url: "https://media.istockphoto.com/id/857747340/photo/water-splash-of-the-washing-machine-drum.jpg?s=612x612&w=0&k=20&c=gMM1GWjpnuWe28FhH5uyGJ6eTG53R93THOsBrIsZwD8="
  },
  {
    email: "skoon@example.com",
    first_name: "Thando",
    last_name: "Khumalo",
    address: "V&A Waterfront, Cape Town, 8001",
    laundromat_name: "Skoon Laundromats - Portside",
    phone_number: "021 419 7890",
    image_url: "https://media.istockphoto.com/id/1386479313/photo/laundromat-washing-machines-in-a-row.jpg?s=612x612&w=0&k=20&c=myEi6jQZjVMGRz5ZQgJnfpHjKhOqN9ubnmqgKkNxB1I="
  },
  {
    email: "greenlaundry@example.com",
    first_name: "Johannes",
    last_name: "Petersen",
    address: "Woodstock, Cape Town",
    laundromat_name: "Green Laundry",
    phone_number: "021 424 3456",
    image_url: "https://media.istockphoto.com/id/1419491563/photo/clean-folded-clothes-stacked-in-laundry-basket.jpg?s=612x612&w=0&k=20&c=HrF5M_-LPKrjNV7KJVdnhgqCLF7nwE6jKE7fV4uGtK8="
  },
  {
    email: "freshclean@example.com",
    first_name: "Pieter",
    last_name: "Ndlovu",
    address: "Canterbury Street, Observatory, Cape Town, 7925",
    laundromat_name: "Fresh & Clean Observatory",
    phone_number: "021 448 2345",
    image_url: "https://media.istockphoto.com/id/1346705134/photo/laundry-shop-interior-with-counter-and-washing-machines-3d-rendering.jpg?s=612x612&w=0&k=20&c=xJWp30P7LzfnFTWtXaCmhTRSxdowWITOKhqNlrM1hc0="
  },
  {
    email: "sudsandspins@example.com",
    first_name: "Bongani",
    last_name: "Jacobs",
    address: "Mill Street, Gardens, Cape Town, 8001",
    laundromat_name: "Suds & Spins",
    phone_number: "021 461 7890",
    image_url: "https://media.istockphoto.com/id/1329022730/photo/stack-of-folded-towels-and-detergents-on-white-table-in-bathroom.jpg?s=612x612&w=0&k=20&c=hiH5LkPeRA7eb-AMVRRwww-idqKEkF3ruEfecW7vjto="
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
  laundromat = Laundromat.create!(
    name: data[:laundromat_name],
    address: data[:address],
    phone_number: data[:phone_number],
    user: owner
  )
  begin
    file = URI.open(data[:image_url])
      laundromat.photos.attach(
        io: file,
        filename: "#{data[:laundromat_name].parameterize}.jpg",
        content_type: "image/jpeg"
      )
    rescue OpenURI::HTTPError, SocketError => e
      puts ":warning: Could not fetch image for #{data[:laundromat_name]}: #{e.message}"

    end
    laundromats << laundromat
# -----------------------------------
puts ":car: Creating drivers..."
drivers = 8.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address: Faker::Address.full_address,
    role: :driver
  )
end
# -----------------------------------
puts ":standing_person: Creating customers..."
customers = 15.times.map do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    first_name: SA_FIRST_NAMES.sample,
    last_name: SA_NAMES.sample,
    address: "#{rand(1..100)} #{['Kloof', 'Buitenkant'].sample} St, #{CAPE_TOWN_AREAS.sample}, 8000",
    role: :customer
  )
end
# -----------------------------------
puts ":package: Creating orders, items, tracking and reviews..."
statuses = ["pending", "processing", "in_transit", "delivered"]
50.times do
  customer = customers.sample
  laundromat = laundromats.sample
  order = Order.create!(
    user: customer,
    laundromat: laundromat,
    pickup_time: Faker::Time.forward(days: 1, period: :morning),
    delivery_time: Faker::Time.forward(days: 2, period: :evening),
    status: statuses.sample,
    total_price: 0
  )
  total = 0
  rand(3..6).times do
    item = CLOTHING_ITEMS.sample
    quantity = rand(1..4)
    price = item[:price] * quantity
    total += price
    OrderItem.create!(
      order: order,
      item_type: item[:name],
      quantity: quantity,
      price: price
    )
  end
  order.update!(total_price: total)
  # Add tracking history based on current status
  status_index = statuses.index(order.status)
  statuses[0..status_index].each_with_index do |s, i|
    OrderTracking.create!(
      order: order,
      status: s,
      notes: "Status changed to #{s}",
      created_at: order.created_at + i.hours
    )
  end
  # Add review if delivered
  if order.status == "delivered"
    Review.create!(
      user: customer,
      laundromat: laundromat,
      content: Faker::Restaurant.review,
      rating: rand(3..5)
    )
  end
end
puts ":white_check_mark: Seeding complete!"
puts "- #{User.count} users"
puts "- #{Laundromat.count} laundromats"
puts "- #{Order.count} orders"
puts "- #{OrderItem.count} items"
puts "- #{Review.count} reviews"
puts "- #{OrderTracking.count} tracking updates"
end
