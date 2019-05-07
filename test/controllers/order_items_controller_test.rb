require "test_helper"

describe OrderItemsController do
  describe "create" do
    before do
      @product = products(:one)
      @order = orders(:one)

      @order_item_data = {
        order_item: {
          product_id: @product.id,
          quantity: 2,
          order_id: @order.id,
        },
      }
    end

    it "can create a new order item" do
      expect {
        post product_order_items_path(@product), params: @order_item_data
      }.must_change "OrderItem.count", 1

      expect(session[:order_id]).wont_be_nil
      expect(flash[:status]).must_equal :success
      must_respond_with :found
      must_redirect_to root_path
    end

    it "needs a valid product" do
      expect {
        post product_order_items_path(-1), params: @order_item_data
      }.wont_change "OrderItem.count"

      must_respond_with :not_found
    end

    it "requires enough stock" do
      product = products(:no_stock)
      expect {
        post product_order_items_path(product), params: @order_item_data
      }.wont_change "OrderItem.count", 1
      expect(flash[:status]).must_equal :error
      expect(flash[:message]).must_include "not enough"
      must_redirect_to root_path
    end

    it "is connected to a product" do
      order_item = OrderItem.new(product_id: @product.id, quantity: 1, order_id: @order.id)
      expect(order_item.product).must_equal @product
    end

    it "has a quantity" do
      order_item = OrderItem.new(product_id: @product.id, quantity: 1, order_id: @order.id)
      expect(order_item.quantity).must_equal 1
    end

    it "is associated with an Order" do
      order = Order.last
      order_item = OrderItem.last

      expect(order.order_items).wont_be_nil
      expect(order_item.order_id).must_equal order.id
    end

  end

end
