class CreateStravaActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :strava_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :resource_state
      t.string :name
      t.float :distance
      t.integer :moving_time
      t.integer :elapsed_time
      t.float :total_elevation_gain
      t.string :type
      t.string :sport_type
      t.bigint :strava_id
      t.datetime :start_date
      t.datetime :start_date_local
      t.string :timezone
      t.float :utc_offset
      t.string :location_city
      t.string :location_state
      t.string :location_country
      t.string :map_id
      t.text :map_summary_polyline
      t.string :gear_id
      t.string :external_id
      t.json :raw_data

      t.timestamps
    end

    add_index :strava_activities, :strava_id, unique: true
  end
end
