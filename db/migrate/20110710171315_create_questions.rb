class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string  :content
      t.string  :slug
      t.string  :location
      t.float   :latitude
      t.float   :longitude
      t.integer :user_id
      
      t.timestamps
    end
  end
end
