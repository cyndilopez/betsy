require "test_helper"

describe Review do
  let(:review) { reviews(:one) }
  describe "relations" do
    it "belongs to a product" do
      review.product.must_be_instance_of Product
      review.product.name.must_equal products(:one).name
    end
  end

  describe "validations" do
    it "is valid for parameters meeting restrictions" do
      expect(review.valid?).must_equal true
    end

    it "requires a name" do
      review.name = nil
      expect(review.valid?).must_equal false
    end

    it "requires a comment" do
      review.comment = nil
      expect(review.valid?).must_equal false
    end

    it "requires an integer as rating between 1 and 5" do
      invalid_ratings = ["string", nil, -1, 1.34, 6, 0]
      invalid_ratings.each do |invalid_rating|
        review.rating = invalid_rating
        expect(review.valid?).must_equal false

        valid_ratings = 1..5
        valid_ratings.each do |valid_rating|
          review.rating = valid_rating
          expect(review.valid?).must_equal true
        end
      end
    end
  end
end
