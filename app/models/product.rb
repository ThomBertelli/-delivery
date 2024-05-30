class Product < ApplicationRecord
  belongs_to :store
  has_many :orders, through: :order_items

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }


end
