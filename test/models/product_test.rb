require "test_helper"

describe Product do
  let(:product) { products(:starbursts) }

  describe "validations" do
    it "is valid for name and price restrictions" do
      expect(product.valid?).must_equal true
    end

    it "requires a name" do
      product = Product.new(price: 10.12)
      expect(product.valid?).must_equal false
    end

    it "requies a price" do
      product = Product.new(name: "Bob")
      expect(product.valid?).must_equal false
    end

    it "requires name to be unique" do
      product_dup = Product.new(name: product.name, price: 10.11, merchant: merchants(:bob))
      expect(product_dup.valid?).must_equal false
      product_dup.errors.messages.must_include :name
    end

    it "requires price to be a number" do
      product.price = "string"
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
    end

    it "requires price to be greater than 0" do
      product.price = 0
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :price
    end

    it "requires a merchant" do
      product.merchant = nil
      expect(product.valid?).must_equal false
      expect(product.errors.messages).must_include :merchant
    end
  end

  describe "relations" do
    it "has categories" do
      product = products(:starbursts)
      expect(product.categories.length).must_equal 2

      category = categories(:confection)
      expect(category.products.length).must_equal 1
    end

    it "has order_items" do
      product = products(:starbursts)
      expect(product.order_items.count).must_equal 2
      expect(product.order_items.first).must_be_instance_of OrderItem
    end

    it "has reviews" do
      product = products(:one)
      expect(product.reviews.count).must_equal 1
      expect(product.reviews.first).must_be_instance_of Review
    end

    it "has a merchant" do
      product = products(:cupcakes)
      merchant = merchants(:jenkins)
      expect(product.merchant).must_be_instance_of Merchant
      expect(product.merchant.name).must_equal merchant.name
    end
  end
end
