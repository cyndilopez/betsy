class MerchantsController < ApplicationController
  skip_before_action :require_login


  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      # Merchant was found in the database
      flash[:status] = :success
      flash[:message] = "Logged in as returning merchant #{merchant.name}"
    else
      # Merchant doesn't match anything in the DB
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:status] = :success
        flash[:message] = "Logged in as new merchant #{merchant.name}"
      else
        flash[:status] = :error
        flash[:message] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:merchant_id] = merchant.id
    redirect_to root_path
  end

  def destroy
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:message] = "Successfully logged out"
    redirect_to root_path
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])

    unless @merchant
      head :not_found
      return
    end

    unless session[:merchant_id] == @merchant.id
      flash[:status] = :error
      flash[:message] = "You don't have permission to view this merchant's page."
      redirect_to root_path
    end
  end
end
