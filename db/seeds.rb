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
# db/seeds.rb

# Clear existing# Clear existing data in development

if Rails.env.development?
  puts "🧹 Cleaning existing data..."
  Message.destroy_all
  OrderTracking.destroy_all
  OrderItem.destroy_all
  Order.destroy_all
  Review.destroy_all
  Laundromat.destroy_all
  User.destroy_all
  puts "✅ Cleaned existing data"
end

# Create Users
puts "👥 Creating users..."

# Regular customers
customers = []
customers << User.create!(
  email: "john.doe@example.com",
  password: "password123",
  first_name: "John",
  last_name: "Doe",
  address: "123 Main Street, Cape Town, 8001",
  role: 0 # assuming 0 is customer role
)

customers << User.create!(
  email: "sarah.wilson@example.com",
  password: "password123",
  first_name: "Sarah",
  last_name: "Wilson",
  address: "456 Oak Avenue, Stellenbosch, 7600",
  role: 0
)

customers << User.create!(
  email: "mike.johnson@example.com",
  password: "password123",
  first_name: "Mike",
  last_name: "Johnson",
  address: "789 Pine Road, Paarl, 7646",
  role: 0
)

customers << User.create!(
  email: "emma.brown@example.com",
  password: "password123",
  first_name: "Emma",
  last_name: "Brown",
  address: "321 Cedar Lane, Somerset West, 7130",
  role: 0
)

# Laundromat owners
owners = []
owners << User.create!(
  email: "owner1@cleanwise.co.za",
  password: "password123",
  first_name: "David",
  last_name: "Smith",
  address: "15 Business Park Drive, Cape Town, 8001",
  role: 1 # assuming 1 is owner/business role
)

owners << User.create!(
  email: "owner2@freshclean.co.za",
  password: "password123",
  first_name: "Lisa",
  last_name: "Adams",
  address: "88 Commercial Street, Stellenbosch, 7600",
  role: 1
)

puts "✅ Created #{User.count} users"

# Create Laundromats
puts "🏪 Creating laundromats..."

laundromats = []

laundromats << Laundromat.create!(
  name: "CleanWise Express",
  address: "234 Long Street, Cape Town, 8001",
  phone_number: "+27 21 123 4567",
  user: owners[0],
  decription: "Modern self-service laundromat with high-efficiency machines. We offer wash, dry, and fold services with same-day turnaround."
)

laundromats << Laundromat.create!(
  name: "Fresh & Clean Stellenbosch",
  address: "67 Dorp Street, Stellenbosch, 7600",
  phone_number: "+27 21 234 5678",
  user: owners[1],
  decription: "Family-owned laundromat serving the Stellenbosch community for over 15 years. Specializing in delicate fabrics and eco-friendly cleaning."
)

laundromats << Laundromat.create!(
  name: "Suds & Bubbles",
  address: "145 Main Road, Sea Point, 8005",
  phone_number: "+27 21 345 6789",
  user: owners[0],
  decription: "Premium laundry service with pickup and delivery. Perfect for busy professionals and families."
)

laundromats << Laundromat.create!(
  name: "Wash World Bellville",
  address: "92 Voortrekker Road, Bellville, 7530",
  phone_number: "+27 21 456 7890",
  user: owners[1],
  decription: "24-hour automated laundromat with state-of-the-art equipment. Perfect for shift workers and busy schedules."
)

laundromats << Laundromat.create!(
  name: "Green Clean Co.",
  address: "78 Kloof Street, Gardens, 8001",
  phone_number: "+27 21 567 8901",
  user: owners[0],
  decription: "Eco-friendly laundromat using biodegradable detergents and energy-efficient machines. We care about your clothes and the environment."
)

laundromats << Laundromat.create!(
  name: "Quick Wash Express",
  address: "203 Main Road, Wynberg, 7800",
  phone_number: "+27 21 678 9012",
  user: owners[1],
  decription: "Fast and reliable laundry service with express 2-hour wash and fold option. Student discounts available."
)

puts "✅ Created #{Laundromat.count} laundromats"

# Add photos to laundromats
puts "📷 Adding photos to laundromats..."

# Sample laundromat photos (you can replace these URLs with actual images)
laundromat_photos = [
  "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop", # Modern laundromat interior
  "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=800&h=600&fit=crop", # Clean laundromat with machines
  "https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=800&h=600&fit=crop", # Bright laundromat space
  "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=600&fit=crop", # Professional laundry service
  "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=800&h=600&fit=crop", # Eco-friendly laundromat
  "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop"  # Express laundromat
]

laundromats.each_with_index do |laundromat, index|
  begin
    # Download and attach the image
    require 'open-uri'
    require 'tempfile'

    image_url = laundromat_photos[index]
    temp_file = Tempfile.new(['laundromat', '.jpg'])
    temp_file.binmode

    # Download the image
    URI.open(image_url) do |image|
      temp_file.write(image.read)
    end
    temp_file.rewind

    # Attach to laundromat
    laundromat.photos.attach(
      io: temp_file,
      filename: "#{laundromat.name.parameterize}.jpg",
      content_type: 'image/jpeg'
    )

    temp_file.close
    temp_file.unlink

    puts "   📸 Added photo to #{laundromat.name}"
  rescue => e
    puts "   ⚠️  Failed to add photo to #{laundromat.name}: #{e.message}"
  end
end

puts "✅ Finished adding photos to laundromats"

# Create Orders
puts "📦 Creating orders..."

orders = []

# Order 1 - Delivered
order1 = Order.create!(
  user: customers[0],
  laundromat: laundromats[0],
  pickup_time: 2.days.ago,
  delivery_time: 1.day.ago,
  total_price: 125.50,
  status: 3 # delivered
)
# Order 2 - Pending
order2 = Order.create!(
  user: customers[1],
  laundromat: laundromats[1],
  pickup_time: 1.day.ago,
  delivery_time: Time.current + 4.hours,
  total_price: 89.75,
  status: 1 # pending
)

# Order 3 - Unconfirmed
order3 = Order.create!(
  user: customers[2],
  laundromat: laundromats[2],
  pickup_time: Time.current + 2.hours,
  delivery_time: nil,
  total_price: 156.25,
  status: 0 # unconfirmed (default)
)

# Order 4 - Pending
order4 = Order.create!(
  user: customers[3],
  laundromat: laundromats[3],
  pickup_time: 6.hours.ago,
  delivery_time: Time.current + 1.hour,
  total_price: 67.50,
  status: 1 # pending
)

# Order 5 - Another delivered order
order5 = Order.create!(
  user: customers[0],
  laundromat: laundromats[4],
  pickup_time: 5.days.ago,
  delivery_time: 4.days.ago,
  total_price: 198.00,
  status: 3 # delivered
)

orders = [order1, order2, order3, order4, order5]

puts "✅ Created #{Order.count} orders"

# Create Order Items
puts "🧺 Creating order items..."

# Order 1 items
OrderItem.create!([
  { order: order1, item_type: "Dress Shirt", quantity: 3, price: 35.00 },
  { order: order1, item_type: "Suit Jacket", quantity: 1, price: 65.50 },
  { order: order1, item_type: "Tie", quantity: 2, price: 25.00 }
])

# Order 2 items
OrderItem.create!([
  { order: order2, item_type: "Jeans", quantity: 2, price: 45.00 },
  { order: order2, item_type: "T-Shirt", quantity: 4, price: 32.00 },
  { order: order2, item_type: "Sweater", quantity: 1, price: 12.75 }
])

# Order 3 items
OrderItem.create!([
  { order: order3, item_type: "Silk Blouse", quantity: 2, price: 48.00 },
  { order: order3, item_type: "Wool Skirt", quantity: 1, price: 28.00 },
  { order: order3, item_type: "Cashmere Scarf", quantity: 1, price: 35.00 },
  { order: order3, item_type: "Evening Dress", quantity: 1, price: 45.25 }
])

# Order 4 items
OrderItem.create!([
  { order: order4, item_type: "Polo Shirt", quantity: 3, price: 42.50 },
  { order: order4, item_type: "Shorts", quantity: 2, price: 25.00 }
])

# Order 5 items
OrderItem.create!([
  { order: order5, item_type: "Business Suit", quantity: 1, price: 85.00 },
  { order: order5, item_type: "Dress Shirt", quantity: 5, price: 75.00 },
  { order: order5, item_type: "Blazer", quantity: 1, price: 38.00 }
])

puts "✅ Created #{OrderItem.count} order items"

# Create Order Trackings
puts "📊 Creating order trackings..."

# Order 1 tracking (delivered)
OrderTracking.create!([
  { order: order1, status: "Order Received", notes: "Order confirmed and scheduled for pickup", created_at: 2.days.ago },
  { order: order1, status: "Picked Up", notes: "Items collected from customer address", created_at: 2.days.ago + 2.hours },
  { order: order1, status: "In Progress", notes: "Washing and dry cleaning in progress", created_at: 2.days.ago + 4.hours },
  { order: order1, status: "Ready for Delivery", notes: "All items cleaned and ready", created_at: 1.day.ago - 2.hours },
  { order: order1, status: "Delivered", notes: "Successfully delivered to customer", created_at: 1.day.ago }
])

# Order 2 tracking (pending)
OrderTracking.create!([
  { order: order2, status: "Order Received", notes: "Order confirmed", created_at: 1.day.ago },
  { order: order2, status: "Picked Up", notes: "Items collected", created_at: 1.day.ago + 1.hour },
  { order: order2, status: "In Progress", notes: "Currently washing", created_at: 4.hours.ago }
])

# Order 3 tracking (unconfirmed)
OrderTracking.create!(
  order: order3,
  status: "Order Received",
  notes: "Order submitted, awaiting confirmation",
  created_at: 1.hour.ago
)

# Order 4 tracking (pending)
OrderTracking.create!([
  { order: order4, status: "Order Received", notes: "Order confirmed", created_at: 8.hours.ago },
  { order: order4, status: "Picked Up", notes: "Items collected", created_at: 6.hours.ago },
  { order: order4, status: "In Progress", notes: "Quick wash cycle", created_at: 5.hours.ago },
  { order: order4, status: "Ready for Delivery", notes: "Items ready for pickup", created_at: 2.hours.ago }
])

puts "✅ Created #{OrderTracking.count} order tracking records"

# Create Reviews
puts "⭐ Creating reviews..."

Review.create!([
  {
    user: customers[0],
    laundromat: laundromats[0],
    rating: 5,
    content: "Excellent service! My clothes came back spotless and smelling fresh. The pickup and delivery was punctual. Highly recommend CleanWise Express!",
    created_at: 1.day.ago
  },
  {
    user: customers[1],
    laundromat: laundromats[1],
    rating: 4,
    content: "Great family-run business. They take good care of delicate fabrics. Only minor issue was the delivery was 30 minutes late, but they called to inform me.",
    created_at: 3.days.ago
  },
  {
    user: customers[2],
    laundromat: laundromats[2],
    rating: 5,
    content: "Premium service as advertised! Worth every penny. My business suits have never looked better. The delicate fabric handling is particularly impressive.",
    created_at: 1.week.ago
  },
  {
    user: customers[3],
    laundromat: laundromats[3],
    rating: 3,
    content: "Convenient 24-hour service, but the machines could use some maintenance. Some of the washers didn't spin properly. Good for emergencies though.",
    created_at: 2.weeks.ago
  },
  {
    user: customers[0],
    laundromat: laundromats[4],
    rating: 5,
    content: "Love that they use eco-friendly products! My sensitive skin appreciates it, and my clothes feel softer. Great environmental initiative.",
    created_at: 4.days.ago
  },
  {
    user: customers[1],
    laundromat: laundromats[5],
    rating: 4,
    content: "Quick and efficient! The 2-hour service saved my day when I needed clean clothes for an important meeting. Student discount is a nice touch.",
    created_at: 5.days.ago
  }
])

puts "✅ Created #{Review.count} reviews"

# Create Messages
puts "💬 Creating messages..."

Message.create!([
  {
    user: customers[0],
    order: order1,
    body: "Hi, just wanted to confirm that my dry cleaning pickup is scheduled for 2 PM today?",
    created_at: 2.days.ago
  },
  {
    user: owners[0],
    order: order1,
    body: "Yes, that's correct! Our driver will be there between 2-2:30 PM. We'll send you updates as we process your items.",
    created_at: 2.days.ago + 15.minutes
  },
  {
    user: customers[1],
    order: order2,
    body: "Could you please add fabric softener to my order? I have sensitive skin.",
    created_at: 1.day.ago
  },
  {
    user: owners[1],
    order: order2,
    body: "Absolutely! We've added hypoallergenic fabric softener to your order. No additional charge for this service.",
    created_at: 1.day.ago + 10.minutes
  },
  {
    user: customers[2],
    order: order3,
    body: "I have a wine stain on one of the silk blouses. Can you handle delicate fabrics?",
    created_at: 2.hours.ago
  },
  {
    user: owners[0],
    order: order3,
    body: "No problem! We specialize in stain removal. We'll treat that wine stain with our premium cleaning process.",
    created_at: 1.hour.ago
  }
])

puts "✅ Created #{Message.count} messages"

# Summary
puts "\n🎉 Seed data created successfully!"
puts "📊 Summary:"
puts "   • #{User.count} users (#{User.where(role: 0).count} customers, #{User.where(role: 1).count} owners)"
puts "   • #{Laundromat.count} laundromats"
puts "   • #{Order.count} orders"
puts "   • #{OrderItem.count} order items"
puts "   • #{OrderTracking.count} tracking records"
puts "   • #{Review.count} reviews"
puts "   • #{Message.count} messages"
puts "\n🔐 Login credentials:"
puts "   Customer: john.doe@example.com / password123"
puts "   Owner: owner1@cleanwise.co.za / password123"
