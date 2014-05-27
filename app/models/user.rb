# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = %w[admin user]

  scope :active, -> { where(active: true) }
  scope :deactivated, -> { where(active: false) }

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role, :active

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

  field :role,                    type: String,   default: 'user'
  field :active,                  type: Boolean,  default: true

  validates :name, :email, :role, presence: true
  validates :role, inclusion: ROLES

  def first_name
    name.split("\s").first if name.present?
  end

  def admin?
    self.role == 'admin'
  end

  def active_for_authentication?
    super and self.active
  end
end