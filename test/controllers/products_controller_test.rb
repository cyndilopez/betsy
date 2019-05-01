require "test_helper"

describe ProductsController do
  describe "index" do
  end

  describe "show" do
  end

  describe "new" do
    it "can get to the new form page" do
      get new_product_path
      
      must_respond_with :ok
    end
  end
  
  describe "create" do
    before do
      @merchant = Merchant.first
    end
    
    it "creates a new product" do  
      product_data = {
        product: {
          name: "amy's test name",
          description: "description",
          price: 4.99,
          photoURL: "github.com",
          stock: 8,
          merchant_id: @merchant.id,
        },
      }
    
      expect {
        post products_path, params: product_data
      }.must_change "Product.count", +1
      
      must_respond_with :redirect
      must_redirect_to products_path
      
      product = Product.last
      expect(product.name).must_equal product_data[:product][:name]
      expect(product.id).wont_be_nil
      
    end
    
    it "sends back a bad request if product couldn't be created" do
      
      product_data = {
        product: {
          name: "",
          description: "description",
          price: 4.99,
          photoURL: "github.com",
          stock: 8,
          merchant_id: @merchant.id,
        }
      }
      
      expect(Product.new(product_data[:product])).wont_be :valid?
      
      expect {
        post products_path, params: product_data
      }.wont_change "Product.count"
      
      must_respond_with :bad_request
      
      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil
    end
  end

  describe "edit" do
  end

  describe "update" do
  end
end
