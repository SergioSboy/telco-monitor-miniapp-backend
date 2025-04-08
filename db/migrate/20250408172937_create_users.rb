# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid do |t|
      t.bigint :telegram_id, null: false
      t.string :username, null: false
      t.string :first_name
      t.string :last_name
      t.string :state, default: 'active', null: false
      t.timestamps
    end

    add_index :users, :telegram_id, unique: true
  end
end
