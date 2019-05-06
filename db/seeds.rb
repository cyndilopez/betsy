# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seed_categories = [
  {
    name: "cake",
  },
  {
    name: "chocolate"
  },
  {
    name: "candy"
  },
  {
    name: "holiday"
  }
]

category_failures = []
seed_categories.each do |seed_cat|
  category = Category.new(name: seed_cat[:name])
  successful = category.save
  if successful
    puts "Created category: #{category.inspect}"
  else
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"


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
    photoURL: "https://lh3.googleusercontent.com/fF9dida8l8SyA2G9Biz7Z70symFY_FRclN7aEQSP01O4wg5G9W19xsy3yjcqKTUANj4KsbMa0dhR4JK_VCtHdKlW8FnskMCGeJbzQA7NCbKQl-5DTLFjHhBsMFbHfazDSH14C9-TsKurIbMWZOpMPZ3K95uxJtw-hiZePbaWOXEWAN38bDzmXI-j7GpwTV2qFGSO2gZkaRCOgGEPPqDbnd0WxOqLPmVy57A7zDcd3FA94_ZAlUe7OQFJk7kh1yZD5MK473WqINaMPoi7runKQQfzYmHSMEXWMx5OXS1uz0gansuFxVIQJgdTDbN0ueVQAchbwdXNwvI7pqx1lxOF63lcygUr7k1KK9Jy6TL8n4EGZK5eivrSaIcIlFj72u9b_9DxN1EUMENrWD0diPNyOCVCimTrT9Xe2pKBXqGy6gx3BFgjGslthJ03RGsyjwh0xvQCB13K6qMJYDcspgpx5EY-8G171bUSph4OxVv8GnGXHwF6hSd-espFH2NghYtFz0GfYiTaqx4DFYng0Qvx5p-xIsdeB0IonrSuQNh_3qY1_F3WGQfha3M35QJZqKTaN11NapEtXXQ77PjbncXdDaZoQrwe2ihA9e7BO9lZg55-ngWdTZuI87CC9ZnWTJqDxXEhkZrP2nFPTUfN6tYDBYEDGB0qL81Ekn8hJt40fAWI9u_yW-eCMTBOXSV7Gwfb_-GlZ7PniypkIVcry1iwK51u=w300-h250-no",
    stock: 8,
    merchant_id: 1,
    category_ids: [1, 4]
  },
  {
    name: "Sprinkle Cupcake",
    description: "Giant cupcake",
    price: 6,
    photoURL: "https://lh3.googleusercontent.com/Gueh5gmLFdItlqstZd8bHBmP0YNweql392uryE3KvC5bxEX7uBF_xok8BN4JAZEm5Dpym8SbLXLV59aGjr84otmFgK6Ho3F8uavIV8GAoXprM1RMV59LAQDQN1-9nrKMLp9XwkhftjlW-WGX-rLHMJrCMTOlbIGgIu0X9tA_J9addc7OXaCgBH6ema3SQv7f8LhfyWc_iZLShhQ2_qcvOjWHA0MwzY4JmyOR6F2u-PVqKTV8dhpyJFDl_O7ZDvbAh9O0SBlkok6fsq6IPGGszc3aW0BmATMdwQnOjmqM-G6VdXMh1Q9_gC7w-vuFk-2UcRslOWpmX_fp90KxrxWJQD5tynHDc4XgZxVmV02GlEicdlqb0u8q2NN7m4m-w1GIh7d-3l--1vv0dRy9N6DbyQVdt970xQrmVqkXGnpCGyn-3RhcJzUAmco5Vl6-iEIii16OyhDIv6B1Ev1YRS1UwDEgIIhmu3z1GKom3JE10UJLz7dLTyj1wEWSeEIjAw77hmSn3gSp85E9ryOiJyApeNl6vL7TAYk2eyefwpQuqO0xJqCqrDO1kGjGhyh6wVdJkmH3X6qB3uAA4BBTBSxUGgSq0bIIg_cr8kUW9mHy70Vx36c9DxKK4YvwPTxUF2S_Na7GEPgCU5RQldjDo0Hm7WepcozOZL3DAf5wtxzi3X7k5Yo5ya8VA_VfULzLtXfugwoPR3lxqlLpeM0K1i85fssQwQ=w300-h250-no",
    stock: 20,
    merchant_id: 1,
    category_ids: [2]
  },
  {
    name: "Chocolate Ice Cream",
    description: "Classic chocolate ice cream in sugar cone",
    price: 5.50,
    photoURL: "https://lh3.googleusercontent.com/H-4fcXlWSpSN5Bk-3TVRnQKH55PN2nYDkuUb05e0gAi63m4EMH2KvinYllyyEH-HPUEM9io754xellLsb1TJjJB-CrhWTO7bst076uSpB_iH_Wi6qIJcWQ7nfYIyPa1QeOQFecObfZZpmJgZVhMoaF8MdlcH-OzBRuyDUxvMoJ4LptLXM5DdIpuhYA4inlCdBjf-Kfc2uF3WhXOkCPLNoyLa4jiA_B2MVZd7_IqV83vn2goxrldmhja2ewpURirzkUI9caaEsZG84Tw747__4nfRaCilVAfYKpwvQjGdgVKfNALD28HtJU5THeShXQKfODyVr4-zoeeA7H9aUmHOw9Ukzh8joQPCavIgKpkgrJ5EbtWrXEscSEv325hOgNWf9HvqMRpQP0hvX9zim0XywSFsXgSzjN3PSXlRlPurjiplwBtWcnDUXkBMCAN2uREYvYZ7my1cl5pTekJDntdr6gBK6ZbWEqWtsdYbi_BtB039WigXHdyiVrDxNlBMLcQ_Y2juAQBg7sszQLHXr0Alkv_wZ1_HUeLpmxZ1u4O93FlxXqLgMsaNNlOVJTvfAamXMc_KqQZZOWsMy628Wl1KBnAUX7Uyfo18WkZE1Xsjwb4qLn7e9vLOPvNXW54UJNsFqdccae9u67ul8dE3pYhF-8NFmV1rS3FFSTSWMD5MVe16ZJPsrSuHI0Mb4o5hmEV49eVEx2XOTkwt8oWbTdQfMnu3=w300-h250-no",
    stock: 80,
    merchant_id: 2,
    category_ids: [1]
  },
  {
    name: "Choffee Cake",
    description: "Chocolate and coffee cake",
    price: 3.25,
    photoURL: "https://lh3.googleusercontent.com/31dXf23EfpJ0wSDFVHlWwmWdhifoJ35o4OZpJfh2pE6VBZST2GHRZmgfk0VZ5v2NyDwwHGPyPk7VycoEZaV81v8MPhFq6gnFu9OLGYCk9cPmfaKGXHmDdAjBpLBVFkT91GHOK7evYJJITHFN3Fc5YyOiD-Ehp8RSOGMUQKkOUJP0bsCFVOhLgDFe98CRbNOrrneaEZH_FXzaJaFeZfffhXdAm_hL1pKI5oOJuIDBRIFKpWpmCWVLQhhaZYkdrENNAheKecmgAMkfQaIHfk0F-c9hHcr-S19j9mFu1suV3UHLn8T6FRtoh5MZsLa29fWhn_GaKJ7qWlrEhcLvsCO4keSqXAguYcwAiWr2fdS03dbXXqvaNukt9I5Y-JaklYf3MsAYJpnEYyaR_FMj-CNnEAzP-Wflf2zieXo61lly-AoJPxFlh6UnbG-o8AH79rtH8sRvRUoQnR8iUem1PQViwq2vG5Iqlg3Zq_IVUXUHnB9brvujGXiql8P1Rp2CVdldzqGS5alTc_RtohbLWdwzcHPz3rZoQ1RZzXohLvQfGvju9YJspr4B_jrvdiXtrbbpSX8ZQ2MU5w6epjr3AEIhnSLmwop3px7k80qqjjE_oQ4kpG0l_qp5iUBp5awBajIsK9W4ykUE2AIbxQyFVc60Czb_hio-BxnKC3SVS9HsOWOAhBSFfnYC4aKHJTFi_Iwd8oyvht6R8g1JL0f-a665e9SkIg=w300-h250-no",
    stock: 80,
    merchant_id: 2,
    category_ids: [1, 2]
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
  product.category_ids = seed_product[:category_ids]
  successful = product.save
  if successful
    puts "Created product: #{product.inspect}"
  else
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  end
end
