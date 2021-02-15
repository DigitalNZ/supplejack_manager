# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  ROLES = %w[admin user].freeze

  default_scope -> { order_by(name: 1) }
  scope :active, -> { where(active: true) }
  scope :deactivated, -> { where(active: false) }

  devise :recoverable, :rememberable, :trackable, :validatable, :database_authenticatable, :two_factor_authenticatable

  field :name,                    type: String

  ## Database authenticatable
  field :email,                   type: String,   default: ''
  field :encrypted_password,      type: String,   default: ''

  ## Recoverable
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time

  ## Rememberable
  field :remember_created_at,     type: Time

  field :second_factor_attempts_count,  type: Integer, default: 0
  field :encrypted_otp_secret_key,      type: String
  field :encrypted_otp_secret_key_iv,   type: String
  field :encrypted_otp_secret_key_salt, type: String
  field :direct_otp,                    type: String
  field :direct_otp_sent_at,            type: DateTime
  field :totp_timestamp,                type: Time

  ## Trackable
  field :sign_in_count,           type: Integer,  default: 0
  field :current_sign_in_at,      type: Time
  field :last_sign_in_at,         type: Time
  field :current_sign_in_ip,      type: String
  field :last_sign_in_ip,         type: String

  field :role,                    type: String,   default: 'user'
  field :active,                  type: Boolean,  default: true

  field :manage_data_sources,     type: Boolean,  default: false
  field :manage_parsers,          type: Boolean,  default: false
  field :manage_harvest_schedules, type: Boolean,  default: false
  field :manage_link_check_rules, type: Boolean,  default: false
  field :manage_partners,         type: Array, default: []
  field :run_harvest_partners,    type: Array, default: []

  validates :name, :email, :role, presence: true
  validates :role, inclusion: ROLES

  has_one_time_password(encrypted: true)
  after_create :generate_totp

  def first_name
    name.split("\s").first if name.present?
  end

  def admin?
    role == 'admin'
  end

  def run_harvest_partners=(values)
    values = values.reject(&:blank?)
    self[:run_harvest_partners] = values
  end

  def manage_partners=(values)
    values = values.reject(&:blank?)
    self[:manage_partners] = values
  end

  def active_for_authentication?
    super && active
  end

  def need_two_factor_authentication?(request)
    MFA_ENABLED
  end

  def two_factor_qr_code_uri
    provisioning_uri('Supplejack Manager')
  end
  
  # Generate the key required for MFA
  def generate_totp
    return unless MFA_ENABLED

    self.otp_secret_key = generate_totp_secret
    save!
  end

  # Intentionally left blank.
  def send_two_factor_authentication_code(code); end
end
