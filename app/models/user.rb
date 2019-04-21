class User < ApplicationRecord
  has_many :uploads
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
