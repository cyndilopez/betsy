require "test_helper"

describe OrderItemsController do
  before do
    @product = Product.first
  end
  describe "create" do
  
    it "can create a new order item" do
      
      order_item_data = {
        order_item: {
          product_id: @product.id,
          quantity: 2, 
        }
      }
      
      expect {
        post order_items_path, params: order_item_data
      }.must_change "OrderItem.count", 1
      
      
      expect(session[:order_id]).wont_be_nil
      
    end
  end
end
