require "test_helper"

describe ProductsController do
  describe "Guest Users" do
    describe "index" do
      it "renders the page" do
        get products_path

        must_respond_with :success
      end

      # it "renders even if there are zero products" do
      # end
    end

    describe "show" do
      it "returns a 404 if the product doesn't exist" do
        product_id = -1

        get product_path(product_id)

        must_respond_with :not_found
      end

      it "works for a product that exist" do
        product_id = Product.first.id

        get product_path(product_id)

        must_respond_with :ok
      end
    end
  end

  describe "Logged in Users" do
    before do
      perform_login(merchants(:jenkins))
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

        expect(flash[:status]).must_equal :success
        expect(flash[:message]).wont_be_nil
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
          },
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
      before do
        @product = Product.first
      end
      it "responds with OK for a real product" do
        get edit_product_path(@product)

        must_respond_with :ok
      end

      it "responds with not found for a fake product" do
        product_id = Product.last.id + 1

        get edit_product_path(product_id)

        must_respond_with :not_found
      end
    end

    describe "update" do
      before do
        @product = Product.first
        @merchant = Merchant.first
        @product_data = {
          product: {
            name: "Updated",
            description: "description",
            price: 4.99,
            photoURL: "github.com",
            stock: 8,
            merchant_id: @merchant.id,
          },
        }
      end
      it "changes the data on the model" do
        @product.assign_attributes(@product_data[:product])

        expect(@product).must_be :valid?
        @product.reload

        patch product_path(@product), params: @product_data

        must_respond_with :redirect
        must_redirect_to product_path(@product)

        expect(flash[:status]).must_equal :success
        expect(flash[:message]).wont_be_nil

        @product.reload
        expect(@product.name).must_equal(@product_data[:product][:name])
      end

      it "responds with NOT FOUND for a fake product" do
        product_id = Product.last.id + 1
        patch product_path(product_id), params: @product_data
        must_respond_with :not_found
      end

      it "responds with bad request for bad data" do
        @product_data[:product][:name] = ""

        @product.assign_attributes(@product_data[:product])
        expect(@product).wont_be :valid?
        @product.reload

        patch product_path(@product), params: @product_data

        must_respond_with :bad_request
      end
    end
  end

  describe "update_status" do
    before do
      @product = products(:jelly_beans)
      perform_login(merchants(:bob))
    end
    it "updates the 'active' column to false if a merchant marks it as inactive" do
      #Assumption
      expect(@product.active).must_equal true
      expect(session[:merchant_id]).must_equal merchants(:bob).id

      #Act
      patch update_status_product_path(@product)
      @product.reload

      #Assert
      expect(@product.active).must_equal false
    end

    it "updates the 'display' column to true if a product is active" do
    end

    it "won't let an unauthorized merchant alter another merchant's product" do
    end
  end
end
