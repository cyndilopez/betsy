require "test_helper"

describe OrdersController do
  describe "show" do
    it "renders the page" do
      order = orders(:one)
      get order_path(order)

      must_respond_with :success
    end
  end
end
