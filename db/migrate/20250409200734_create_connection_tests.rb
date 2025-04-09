# frozen_string_literal: true

class CreateConnectionTests < ActiveRecord::Migration[8.0]
  def change
    create_table :connection_tests, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.float :ping
      t.float :download_speed
      t.float :upload_speed
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
