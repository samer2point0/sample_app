class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  ValidEmailRegEx= /\A[\w+\d\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_save {email.downcase!}
  before_create :create_activation_digest
  validates :name, {presence: true, length: {maximum: 50}}
  validates :email, {presence: true, length:{maximum: 255},
                     format: {with: ValidEmailRegEx},
                     uniqueness:{case_sensitive: false}
                     }
  validates :password, {presence: true, length: {minimum:6}, allow_nil: true} #has secure password has a second validation for passwords
  attr_accessor :remember_token, :activation_token, :reset_token
  has_secure_password


  def feed
    Micropost.where("user_id=?",id)
  end
  
  def remember
    self.remember_token=User.newToken
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  def authenticated?(attribute, token)
    digest=send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    self.reset_token=User.newToken()
    update_columns(reset_digest: User.digest(reset_token),reset_sent_at: Time.zone.now)
  end

  class<<self
    def digest(passwrod)
      cost= ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                   BCrypt::Engine.cost
      BCrypt::Password.create(passwrod,cost: cost)
    end
    def newToken
      SecureRandom.urlsafe_base64
    end
  end

  private
    def create_activation_digest
      self.activation_token= User.newToken
      self.activation_digest=User.digest(activation_token)
    end

end
