class Payments::HandlePayment

  include Virtus.model

  attribute :user, User
  attribute :stripe_token, String
  attribute :pledge, Pledge

  def call
    customer_service = Payments::Stripe::CreateCustomer.new(user: user,
                                                           stripe_token: stripe_token)
    customer_service.call

    charge = Stripe::Charge.create(
                amount:      pledge.amount * 100,
                currency:    "cad",
                customer:    user.stripe_customer_id,
                description: "Charge for pledge id: #{pledge.id}"
              )

    pledge.stripe_txn_id = charge.id
    pledge.save
  end

end
