class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.string :link
      t.datetime :date
      t.references :feed, foreign_key: true

      t.timestamps
    end
  end
end
