require "test_helper"

describe ProductsController do
  describe "Guest Users" do
    describe "index" do
      it "renders the page" do
        get products_path

        must_respond_with :success
      end

      it "renders even if there are zero products" do
        products = Product.all
        products.each do |product|
          product.destroy
        end
        Product.all.must_be_empty
        get products_path

        must_respond_with :success
      end
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

    describe "create" do
      it "requires a user to be logged in " do
        product_data = {
          product: {
            name: "amy's test name",
            description: "description",
            price: 4.99,
            photoURL: "github.com",
            stock: 8,
            merchant_id: Merchant.first,
          },
        }

        expect {
          post products_path, params: product_data
        }.wont_change "Product.count"
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
        @product = merchants(:jenkins).products.first
        perform_login(merchants(:jenkins))
      end
      it "responds with OK for a real product and an authorized merchant" do
        expect(session[:merchant_id]).must_equal merchants(:jenkins).id
        expect(@product.merchant_id).must_equal merchants(:jenkins).id

        get edit_product_path(@product)

        must_respond_with :ok
      end

      it "responds with not found for a fake product" do
        product_id = Product.last.id + 1

        get edit_product_path(product_id)

        must_respond_with :not_found
      end

      it "doesn't allow a user to edit another merchant's product" do
        product_id = merchants(:bob).products.first.id

        expect(session[:merchant_id]).must_equal merchants(:jenkins).id

        get edit_product_path(product_id)

        expect(flash[:status]).must_equal :error
        expect(flash[:message]).wont_be_nil
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

    it "updates the 'active' column to true if a merchant marks it as active" do
      @product.active = false
      @product.save
      expect(@product.active).must_equal false

      patch update_status_product_path(@product)
      @product.reload

      expect(@product.active).must_equal true
    end

    it "won't let an unauthorized merchant alter another merchant's product" do
      # Arrange/Assumptions
      different_product = products(:one)
      expect(different_product.active).must_equal true

      setup = session[:merchant_id] != different_product.merchant_id
      expect(setup).must_equal true

      # Act
      patch update_status_product_path(different_product)
      different_product.reload

      # Assert
      expect(different_product.active).must_equal true
      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil
    end
  end
end
