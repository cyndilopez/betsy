require "test_helper"

describe Category do
  let(:category) { Category.new }
  describe "validations" do
    it "requires a name" do
      expect(category.valid?).must_equal false
    end

    it "requires name to be unique" do
      category = categories(:cake)
      category_dup = Category.new(name: "cake")
      expect(category_dup.valid?).must_equal false
    end

    it "is valid for name restrictions" do
      category = Category.new(name: "Sweets")
      expect(category.valid?).must_equal true
    end
  end

  describe "relations" do
    it "has products" do
      category = categories(:confection)
      expect(category.products.length).must_equal 1
    end
  end
end
