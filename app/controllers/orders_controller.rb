class OrdersController < ApplicationController
  def create

    @amount = params[:amount]
    @paypal_account = 'jason@jason-lee.net.au'
    @order_id = Time.now.to_i
    @invoice = Time.now.to_i.to_s

  end

end
