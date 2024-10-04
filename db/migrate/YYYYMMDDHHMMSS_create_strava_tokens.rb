class CreateStravaTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :strava_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token_type
      t.integer :expires_at
      t.integer :expires_in
      t.string :refresh_token
      t.string :access_token
      t.integer :athlete_id
      t.string :athlete_username

      t.timestamps
    end

    add_index :strava_tokens, [ :user_id, :expires_at ]
  end
end
