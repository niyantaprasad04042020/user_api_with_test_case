class User
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String

  validates :first_name, :last_name, presence: true
end
