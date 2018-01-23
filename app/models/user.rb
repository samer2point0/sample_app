class User < ApplicationRecord
  ValidEmailRegEx= /\A[\w+\d\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, {presence: true, length: {maximum: 50}}
  validates :email, {presence: true, length:{maximum: 255},
                     format: {with: ValidEmailRegEx},
                     uniqueness:{case_sensitive: false}
                     }
end
