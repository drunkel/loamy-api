class AddLastStravaSyncAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_strava_sync_at, :datetime, null: true
  end
end
