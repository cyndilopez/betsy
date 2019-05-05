require "test_helper"
require "pry"

describe MerchantsController do
  before do
    @merchant = merchants(:jenkins)
  end
  describe "auth callback" do
    before do
      @start_count = Merchant.count
    end
    it "can log in an existing user" do
      perform_login(@merchant)
      session[:merchant_id].must_equal @merchant.id

      Merchant.count.must_equal @start_count
      must_redirect_to root_path
    end

    it "can log in a new user" do
      merchant = Merchant.new(provider: "github", uid: 999999999, name: "ted", username: "test_merchant", email: "test@merchant.com")

      perform_login(merchant)

      must_redirect_to root_path

      Merchant.count.must_equal @start_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "doesn't log in a merchant with bad data" do
      merchant = Merchant.new(provider: "github", uid: 999999999, name: "ted", username: "", email: "test@merchant.com")

      result = merchant.valid?
      expect(result).must_equal false

      perform_login(merchant)

      must_redirect_to root_path

      Merchant.count.must_equal @start_count
      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil
      expect(session[:merchant_id]).must_be_nil
    end
  end

  describe "destroy" do
    before do
      @merchant = merchants(:jenkins)
      perform_login(@merchant)
    end
    it "successfully logs out a merchant" do
      expect(session[:merchant_id]).must_equal @merchant.id
      delete logout_path
      expect(session[:merchant_id]).must_be_nil
      must_redirect_to root_path
      expect(flash[:status]).must_equal :success
      expect([flash[:message]]).wont_be_nil
    end
  end

  describe "show" do
    it "returns a 404 status code if the merchant doesn't exist" do
      merchant_id = 123456789

      get merchant_path(merchant_id)

      must_respond_with :not_found
    end

    it "works for a merchant that exists and is logged in" do
      perform_login(@merchant)
      get merchant_path(@merchant.id)

      must_respond_with :ok
    end

    it "returns an error if a merchant tries to view a different merchant's page" do
      unauthorized_merchant = Merchant.new(provider: "github", uid: 999999999, name: "unauthorized", username: "unauthorized", email: "nope@merchant.com")
      unauthorized_merchant.save

      perform_login(unauthorized_merchant)
      expect(session[:merchant_id]).must_equal unauthorized_merchant.id

      get merchant_path(@merchant)

      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil
    end

    it "returns an error if a guest tries to view a merchant's page" do
      get merchant_path(@merchant)

      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil
    end
  end
end
