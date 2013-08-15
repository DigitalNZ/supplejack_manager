class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  before_save :ensure_authentication_token
  
  field :name,                    type: String

  ## Database authenticatable
  field :email,                   type: String,   default: ""
  field :encrypted_password,      type: String,   default: ""

  ## Recoverable
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time

  ## Rememberable
  field :remember_created_at,     type: Time

  ## Trackable
  field :sign_in_count,           type: Integer,  default: 0
  field :current_sign_in_at,      type: Time
  field :last_sign_in_at,         type: Time
  field :current_sign_in_ip,      type: String
  field :last_sign_in_ip,         type: String

  ## Token authenticatable
  field :authentication_token,    type: String

  def first_name
    name.split("\s").first if name.present?
  end
end