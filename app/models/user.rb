class User < ApplicationRecord
  devise :database_authenticatable,
          :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
