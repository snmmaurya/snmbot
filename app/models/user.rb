class User
  include Mongoid::Document
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ## Database authenticatable
  field :first_name,             type: String, default: ""
  field :last_name,              type: String, default: ""
  field :phone_number,           type: String, default: ""
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  ## Rememberable
  field :remember_created_at, type: Time
  field :status, type: Integer, default: 0
  field :authentication, type: Integer, default: 0
  field :created_at, type: Time
  field :updated_at, type: Time


  has_many :orders
  has_many :bots
end
