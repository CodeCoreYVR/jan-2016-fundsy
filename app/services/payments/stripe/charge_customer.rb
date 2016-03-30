class Payments::Stripe::ChargeCustomer

  include Virtus.model

  attribute :amount, Integer
  attribute :user, User
  attribute :description, String

  attribute :charge_id, String

  def call
    charge_customer
  end

  private

  def charge_customer
    begin
      charge     = call_stripe_charge_customer
      @charge_id = charge.id
    rescue
      false
    end
  end

  def call_stripe_charge_customer
    Stripe::Charge.create(
                amount:      amount,
                currency:    "cad",
                customer:    user.stripe_customer_id,
                description: description
              )
  end

end
