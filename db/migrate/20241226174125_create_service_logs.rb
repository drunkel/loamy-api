class CreateServiceLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :service_logs do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :service_interval, null: false, foreign_key: true
      t.date :completed_on

      t.timestamps
    end
  end
end
