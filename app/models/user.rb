class User < ActiveRecord::Base
  attr_accessor :remember_token
  has_many :remember_digests, dependent: :destroy
  has_many :res_groups, dependent: :destroy

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password

  def remember
    self.remember_token = SecureRandom.urlsafe_base64

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    digest = BCrypt::Password.create(self.remember_token, cost: cost)

    RememberDigest.create(user: self, remember_digest: digest)
  end

  def forget
    self.remember_digests.destroy_all
  end

  def authenticated?(token)
    authenticated = false
    self.remember_digests.each do |digest|
      if BCrypt::Password.new(digest.remember_digest).is_password?(token)
        authenticated = true
        break
      end
    end
    return authenticated
  end

  def default_group
    ResGroup.where(user_id: self.id).find_by_name(Rails.configuration.res_group_reserved_names[0])
  end


  def self.available_users_for(user)
    if user && user.admin?
      User.all
    else
      User.where(id: user)
    end
  end

end
