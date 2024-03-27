class User < ApplicationRecord
  enum :role, [:admin, :seller, :buyer]
  has_many :stores

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_token(token)
    nil
  end
end
