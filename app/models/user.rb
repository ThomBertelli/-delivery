class User < ApplicationRecord
  enum :role, [:admin, :seller, :buyer]
  has_many :stores

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_token(token)
    JWT.decode token , "muito.secreto", {algorithm: 'HS256'}
  end

  def self.token_for(user)
    payload = {id: user.id, email: user.email, role: user.role}
    JWT.encode payload, "muito.secreto", "HS256"
  end


end
