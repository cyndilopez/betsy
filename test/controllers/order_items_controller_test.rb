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
      must_redirect_to products_path
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

  describe "update" do
    before do
      @order_item1 = order_items(:one)
      @order_item2 = order_items(:two)
      @order = @order_item2.order
    end

    it "can update" do
      quantity = 2
      id1 = @order_item1.id.to_s
      id2 = @order_item2.id.to_s
      params = {
        order_items: {
          id1 => quantity,
          id2 => quantity,
        },
      }

      patch order_item_path(@order_item1), params: params

      @order_item1.reload
      @order_item2.reload
      expect(@order_item1.quantity).must_equal 2
      expect(@order_item2.quantity).must_equal 2
      expect(flash[:status]).must_equal :success
      expect(flash[:message]).wont_be_nil
      must_redirect_to order_path(@order)
    end

    it "only updates if amount ordered is less than or equal to amount in stock" do
      quantity = 200
      id1 = @order_item1.id.to_s
      id2 = @order_item2.id.to_s
      params = {
        order_items: {
          id1 => quantity,
          id2 => quantity,
        },
      }

      patch order_item_path(@order_item1), params: params

      expect(flash[:status]).must_equal :error
      expect(flash[:message]).must_include "Unable to add"
      must_redirect_to order_path(@order)
    end

    it "only updates for valid data" do
      quantity = -1
      id1 = @order_item1.id.to_s
      id2 = @order_item2.id.to_s
      params = {
        order_items: {
          id1 => quantity,
          id2 => quantity,
        },
      }

      patch order_item_path(@order_item1), params: params

      expect(flash[:status]).must_equal :error
      expect(flash[:message]).must_include "Unable to update"
      must_redirect_to order_path(@order)
    end
  end

  describe "destroy" do
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
      post product_order_items_path(@product), params: @order_item_data
    end
    it "can destroy an item" do
      start_count = OrderItem.count
      order_item = order_items(:one)
      delete order_item_path(order_item)
      expect(OrderItem.count).must_equal start_count - 1
      expect(flash[:status]).must_equal :success
      expect(flash[:message]).wont_be_nil
      must_redirect_to order_path(session[:order_id])
    end

    it "renders 404 for non-existing order-item" do
      delete order_item_path(-1)
      must_respond_with :not_found
    end
  end
end
