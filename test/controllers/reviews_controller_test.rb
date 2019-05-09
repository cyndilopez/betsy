require "test_helper"

describe ReviewsController do
  describe "new" do
    it "renders the page" do
      product = products(:starbursts)
      get new_product_review_path(product)
      must_respond_with :success
    end

    it "returns a 404 if product not found" do
      get new_product_review_path(-1)
      must_respond_with :not_found
    end

    it "doesn't allow a merchant to review their own product" do
      perform_login(merchants(:bob))
      product = products(:starbursts)
      get new_product_review_path(product)
      must_redirect_to product_path(product)
      flash[:status].must_equal :error
      flash[:message].must_include "can't review"
    end
  end

  describe "create" do
    let(:review_data) {
      {
        review: {
          name: "Cyndi",
          comment: "New review",
          rating: 5,
        },
      }
    }
    let(:product) { products(:starbursts) }
    it "creates a review" do
      expect {
        post product_reviews_path(product), params: review_data
      }.must_change "Review.count", +1
      must_redirect_to product_path(product)
      flash[:status].must_equal :success
      flash[:message].wont_be_nil
    end

    it "returns a 404 if product not found" do
      post product_reviews_path(-1), params: review_data
      must_respond_with :not_found
    end

    it "doesn't allow a merchant to create a product" do
      perform_login(merchants(:bob))
      post product_reviews_path(product), params: review_data
      must_redirect_to product_path(product)
      flash[:status].must_equal :error
      flash[:message].must_include "can't review"
    end

    it "requires valid parameters to create a product" do
      review_data[:review][:rating] = nil
      post product_reviews_path(product), params: review_data
      expect(flash[:status]).must_equal :error
      expect(flash[:message].downcase).must_include "couldn't save"
    end
  end
end
