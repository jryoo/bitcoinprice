require 'open-uri'

class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url

  # Main function that is called by the scheduler add-on
  # Sanitizes the feed (removes harmful stuff - not sure what that means)
  # Calls add_entries
  def self.update_from_feed(feed_url)
  	# feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    feed = JSON.parse(open(feed_url).read())
  	add_entry(feed)
  end

  def self.add_entry(entry)
    amount = entry['total']['amount']
    currency = entry['total']['currency']
    create!(
      :name =>  amount + " " + currency,
      :summary => "Profit Made: " + ((amount.to_f - 545.63)*2).round(2).to_s + " " + currency,
      :url => 'https://coinbase.com/charts',
      :published_at => Time.now.utc.getlocal,
      :guid => amount
    )
    begin
      latest = order("created_at").limit(all.length-1).last
      latest_value = 0
      if latest
        latest_value = ((latest.guid.to_f / 100).to_i) * 100
        puts latest.guid
        puts latest.id
      end
      multhundred_value = ((amount.to_f / 100).to_i) * 100
      puts latest_value
      puts multhundred_value
      if latest_value != multhundred_value
        Member.send_RSS(entry)
        puts "sent RSS"
      end
    rescue
    end
  end

  # # An extra function for testing purposes. It continuously fetches from feed every 15 minutes
  # # Calls add_entries
  # def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
  # 	feed = Feedzirra::Feed.fetch_and_parse(feed_url)
  #   add_entries(feed.entries)
  #   loop do
  #     sleep delay_interval
  #     feed = Feedzirra::Feed.update(feed)
  #     add_entries(feed.new_entries) if feed.updated?
  #   end
  # end

  # private

  # # Main function called by update_from_feed. It adds multiple entries from the feed
  # def self.add_entries(entries)
  # 	entries.each do |entry|
  # 		unless exists? :guid => entry.id
  # 			create!(
  # 				:name			=> entry.title,
  # 				:summary		=> entry.summary,
  # 				:url 			=> entry.url,
  # 				:published_at	=> entry.published,
  # 				:guid 			=> entry.id
  # 			)
  #       begin
  #         Member.send_RSS(entry)
  #         #Twitter.update("[#{entry.published.strftime("%B %d, %Y")}][#{entry.title}] http://www.nolanotify.com/")
  #         Twitter.update("#{entry.title} (#{entry.published.strftime("%B %d, %Y")}) #{entry.url}")
  #       rescue
  #       end
  # 		end
  # 	end
  # end

  # # Function adds a single entry
  # def self.add_entry(entry)
  #   unless exists? :guid => entry.id
  #     create!(
  #       :name     => entry.title,
  #       :summary    => entry.summary,
  #       :url      => entry.url,
  #       :published_at => entry.published,
  #       :guid       => entry.id
  #     )
  #   end
  #   begin
  #     Member.send_RSS(entry)
  #     #Twitter.update("[#{entry.published.strftime("%B %d, %Y")}][#{entry.title}] http://www.nolanotify.com/")
  #     Twitter.update("#{entry.title} (#{entry.published.strftime("%B %d, %Y")}) #{entry.url}")
  #   rescue
  #   end
  # end

  # # Testing purpose
  # def self.update_from_feed_once_testing(feed_url)
  #   feed = Feedzirra::Feed.fetch_and_parse(feed_url)
  #   add_entry(feed.entries[0])
  # end

end
