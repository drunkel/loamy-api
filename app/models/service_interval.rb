class ServiceInterval < ApplicationRecord
  belongs_to :bike
  has_many :service_logs
end
