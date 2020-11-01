require 'open-uri'
require "net/http"
require 'rss'

class Feed < ApplicationRecord
  validates_uniqueness_of :url

  has_many :articles, dependent: :destroy

  before_validation :sanitize_strings
  before_save :set_articles

  private

  def sanitize_strings
    attributes.each { |_, value| value.try(:strip!) }
  end

  def set_articles
    if articles.empty? 
       articles << parse_articles
    end 
  end 
  
  def parse_articles
    data = open(url)
    feed = RSS::Parser.parse(data, false)
    self[:name] = feed.channel.title
    self[:link] = feed.channel.link 
    feed.channel.items.collect do | item |
        parse_description = Nokogiri::HTML(item.description).css("body").text
        item_date = item.date
        item_date = DateTime.now if item_date.nil?
        new_article = Article.create(title: item.title, description: parse_description ,  link: item.link, date: item_date.strftime("%B %d, %Y") )
        new_article
    end
  end
end
