# frozen_string_literal: true

class CreateComplaints < ActiveRecord::Migration[8.0]
  def change
    create_table :complaints, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :problem_type
      t.text :comment
      t.float :latitude
      t.float :longitude
      t.string :ticket_number
      t.string :status

      t.timestamps
    end
  end
end
