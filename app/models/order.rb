class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :store
  has_many :order_items
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items

  validate :buyer_role

  state_machine initial: :created do
    event :accept do
      transition paid: :accepted
    end
    event :reject do
      transition paid: :rejected
    end
    event :payOk do
      transition created: :paid
    end
    event :payError do
      transition created: :notPaid
    end
    event :send_order do
      transition accept: :sended
    end

  
  end

  private

  def buyer_role
    if !buyer.buyer?
      errors.add(:buyer, "should be a 'user.buyer'")
    end
  end
end
