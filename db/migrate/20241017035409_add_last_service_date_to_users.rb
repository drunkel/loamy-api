class AddLastServiceDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_service_date, :date
  end
end
