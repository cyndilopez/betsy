require "test_helper"

describe OrdersController do
  describe "show" do
    it "renders the page" do
      order = orders(:one)
      get order_path(order)

      must_respond_with :success
    end

    it "renders a 404 if order not found" do
      get order_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let(:order_data) {
      {
        order: {
          name: "test-name",
          email: "test@ada.edu",
          address: "Ada Street",
          cc_num: 1234567891012141,
          cc_cvv: 123,
          cc_expiration: "122025",
          zip_code: 12345,
        },
      }
    }
    it "updates an order" do
      order = Order.create(status: "pending")
      patch order_path(order), params: order_data
      order.reload
      # expect(order.status).must_equal "paid"
      expect(flash[:status]).must_equal :success
      expect(flash[:message]).wont_be_nil
      must_redirect_to order_confirmation_path(order)
      expect(session[:order_id]).must_be_nil
    end

    it "renders a 404 if order not found" do
      patch order_path(-1), params: order_data
      must_respond_with :not_found
    end

    it "won't allow you to checkout if parameters invalid" do
      order = Order.create(status: "pending")
      order_data[:order][:name] = nil
      patch order_path(order), params: order_data
      expect(flash[:status]).must_equal :error
      must_redirect_to root_path
    end

    it "updates product stock" do
      order = orders(:three)
      order_item = order_items(:three)
      product = order_item.product
      initial_product_stock = product.stock
      quantity_ordered = order_item.quantity
      patch order_path(order), params: order_data
      order.reload
      product.reload
      after_update_product_stock = product.stock
      after_update_product_stock.must_equal initial_product_stock - quantity_ordered
    end
  end

  describe "confirmation" do
    it "renders the page" do
      order = orders(:two)
      get order_confirmation_path(order)
      must_respond_with :success
    end

    it "renders a 404 if order not found" do
      get order_confirmation_path(-1)
      must_respond_with :not_found
    end
  end
end
