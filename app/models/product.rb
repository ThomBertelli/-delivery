class Product < ApplicationRecord
  belongs_to :store
  has_many :orders, through: :order_items
  has_one_attached :image

  include Discard::Model

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :deleted, -> { where.not(deleted_at: nil) }


end
