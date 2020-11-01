require 'open-uri'
require "net/http"
require 'rss'

namespace :rss do
  desc "Daemon for fetching rss feeds"
  task daemon: :environment do

    begin
      Feed.find_each(batch_size: 10) do |feed|
        begin
          data = open(feed.url)
          fetched_feed = RSS::Parser.parse(data, false)

          fetched_feed.channel.items.collect do | item |
            if Article.where(link: item.link).blank?
              parse_description = Nokogiri::HTML(item.description).css("body").text
              item_date = item.date
              item_date = DateTime.now if item_date.nil?
              new_article = Article.create(
                title: item.title,
                description: parse_description, 
                link: item.link, 
                date: item_date,
                feed_id: feed.id
              )
            end
          end
        rescue => e
          p "Rescued network error: #{e.inspect}"
        end
      end
    rescue => e
      p "Rescued general error: #{e.inspect}"
    end
  end
end
