class ServiceLog < ApplicationRecord
  belongs_to :bike
  belongs_to :service_interval
end
