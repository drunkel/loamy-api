class User < ApplicationRecord
  devise :database_authenticatable,
          :jwt_authenticatable, :registerable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
