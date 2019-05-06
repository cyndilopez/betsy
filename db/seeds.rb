# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seed_merchants = [
  {
    username: "Ninou",
    email: "Ninou@email.com",
  },
  {
    username: "Bebop",
    email: "Bebop.Kim@email.com",
  },
  {
    username: "Swayze",
    email: "Swayze@email.com",
  },
]

merchant_failures = []
seed_merchants.each do |seed_merchant|
  merchant = Merchant.new(username: seed_merchant[:username], email: seed_merchant[:email])
  successful = merchant.save
  if successful
    puts "Created merchant: #{merchant.inspect}"
  else
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

seed_products = [
  {
    name: "Blueberry Ice Cream",
    description: "16oz organic fresh blueberry ice cream",
    price: 12,
    photoURL: "github.com",
    stock: 8,
    merchant_id: 1,
  },
  {
    name: "Sprinkle Cupcake",
    description: "Giant cupcake",
    price: 6,
    photoURL: "https://images.unsplash.com/photo-1541618985631-8e9b3b3e73d8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80",
    stock: 20,
    merchant_id: 1,
  },
  {
    name: "Chocolate Ice Cream",
    description: "Classic chocolate ice cream in sugar cone",
    price: 5.50,
    photoURL: "https://images.unsplash.com/photo-1529972016098-9407f216972e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=975&q=80",
    stock: 80,
    merchant_id: 2,
  },
  {
    name: "Choffee Cake",
    description: "Chocolate and coffee cake",
    price: 3.25,
    photoURL: "https://images.unsplash.com/photo-1549254828-e4d966c1900a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
    stock: 80,
    merchant_id: 2,
  },
]

product_failures = []
seed_products.each do |seed_product|
  product = Product.new
  product.name = seed_product[:name]
  product.description = seed_product[:description]
  product.price = seed_product[:price]
  product.merchant_id = seed_product[:merchant_id]
  product.photoURL = seed_product[:photoURL]
  product.stock = seed_product[:stock]
  successful = product.save
  if successful
    puts "Created product: #{product.inspect}"
  else
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  end
end
