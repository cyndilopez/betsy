require "test_helper"

describe ProductsController do
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

      must_respond_with :redirect
    end
  end

  describe "new" do
  end

  describe "edit" do
  end

  describe "update" do
  end
end
