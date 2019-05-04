require "test_helper"

describe OrderItemsController do

  describe "create" do
    before do
    @product = products(:one)
    @order = orders(:one)
  end
    it "can create a new order item" do
      
      order_item_data = {
        order_item: {
          product_id: @product.id,
          quantity: 2,
          order_id: @order.id
        }
      }
      
      expect {
        post order_items_path, params: order_item_data
      }.must_change "OrderItem.count", 1
      
      expect(session[:order_id]).wont_be_nil
      expect(flash[:status]).must_equal :success
      must_respond_with :found
      must_redirect_to product_path(id: @product.id)
    end
    
    it "is associated with an Order" do
      order = Order.last
      order_item = OrderItem.last
      
      expect(order.order_items).wont_be_nil
      expect(order_item.order_id).must_equal order.id
    end
    
    it "will display an error message if given bad data" do
      order_item_data = {
        order_item: {
          product_id: -1,
          quantity: 1,
          order_id: @order.id
        }
      }
      
      expect {
        post order_items_path, params: order_item_data
      }.wont_change "OrderItem.count"
      
      expect(flash[:status]).must_equal :error
      must_respond_with :redirect
      
    end
  end
end
