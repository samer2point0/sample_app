class User < ApplicationRecord
  ValidEmailRegEx= /\A[\w+\d\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_save {email.downcase!}
  validates :name, {presence: true, length: {maximum: 50}}
  validates :email, {presence: true, length:{maximum: 255},
                     format: {with: ValidEmailRegEx},
                     uniqueness:{case_sensitive: false}
                     }
  validates :password, {presence: true, length: {minimum:6}}

  has_secure_password

  def User.digest(passwrod)
    cost= ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                 BCrypt::Engine.cost
    BCrypt::Password.create(passwrod,cost: cost)
  end
end
