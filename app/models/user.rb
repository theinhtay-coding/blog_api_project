class User < ApplicationRecord
  enum :status, { inactive: 0, active: 1 }
  enum :role, { admin: 1, user: 2 }
  has_secure_password
  validates :email, :company, presence: true
  validates :email, uniqueness: true
end
