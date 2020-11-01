class Article < ApplicationRecord
  belongs_to :feed
  
  scope :desc_by_date,   -> { order("articles.date DESC") }
end
