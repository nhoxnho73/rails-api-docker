# frozen_string_literal: true
class User < ActiveRecord::Base
  PASSWORD_MAX_SIZE = 15
  PASSWORD_MIN_SIZE = 8
  USERNAME_MAX_SIZE = 20
  USERNAME_MIN_SIZE = 8
  has_many :movies
  has_many :device_tokens
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  devise authentication_keys: [:username, :email] # LOGIN with username or email

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :id, :username, :email
    end
  end 

# LOGIN with username or email start
  protected

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  private

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login= conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
    else
      where(conditions.to_h).first
    end
  end
# LOGIN with username or email end
end
