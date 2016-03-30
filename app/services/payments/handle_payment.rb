class Payments::HandlePayment

  include Virtus.model

  attribute :user, User
  attribute :stripe_token, String
  attribute :pledge, Pledge

  def call
    create_customer && charge_customer && update_pledge
  end

  private

  def create_customer
    customer_service = Payments::Stripe::CreateCustomer.new(user: user,
    stripe_token: stripe_token)
    customer_service.call
  end

  def charge_customer
    service = Payments::Stripe::ChargeCustomer.new(user:        user,
                                                   description: description,
                                                   amount:      amount)
    @charge_id = service.charge_id if service.call
  end

  def description
    "Charge for pledge id: #{pledge.id}"
  end

  def amount
    pledge.amount * 100
  end

  def update_pledge
    pledge.stripe_txn_id = @charge_id
    pledge.save
  end

end
