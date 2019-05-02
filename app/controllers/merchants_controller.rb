class MerchantsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      # Merchant was found in the database
      flash[:status] = :success
      flash[:message] = "Logged in as returning merchant #{merchant.name}"
    else
      # Merchant doesn't match anything in the DB
      # TODO: Try to create a new merchant
    end

    session[:merchant_id] = merchant.id
    redirect_to root_path
  end
end
