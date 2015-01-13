class User < ActiveRecord::Base
  has_secure_password

  ROLES = %w(admin)

  def admin?
    role == "admin"
  end
end
