class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendations, id: :uuid do |t|
      t.string :problem_type
      t.text :text
      t.string :link

      t.timestamps
    end
  end
end
