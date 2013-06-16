class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url

  # Main function that is called by the scheduler add-on
  # Sanitizes the feed (removes harmful stuff - not sure what that means)
  # Calls add_entries
  def self.update_from_feed(feed_url)
  	feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    begin
      feed.sanitize_entries!
    rescue
    end
  	add_entries(feed.entries)
  end

  def self.test_feed(feed_url, ind)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    begin
      feed.sanitize_entries!
    rescue
    end
    add_entry_test(feed.entries[ind])
  end


  # An extra function for testing purposes. It continuously fetches from feed every 15 minutes
  # Calls add_entries
  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
  	feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
  end

  private


  # Testing the feed
  def self.add_entry_test(entry)
    begin
      Member.send_RSS_test(entry)
    rescue
    end
  end

  # Main function called by update_from_feed. It adds multiple entries from the feed
  def self.add_entries(entries)
  	entries.each do |entry|
  		unless exists? :guid => entry.id
  			create!(
  				:name			=> entry.title,
  				:summary		=> entry.summary,
  				:url 			=> entry.url,
  				:published_at	=> entry.published,
  				:guid 			=> entry.id
  			)
        begin
          Member.send_RSS(entry)
          #Twitter.update("[#{entry.published.strftime("%B %d, %Y")}][#{entry.title}] http://www.nolanotify.com/")
          Twitter.update("#{entry.title} (#{entry.published.strftime("%B %d, %Y")}) #{entry.url}")
        rescue
        end
  		end
  	end
  end

  # Function adds a single entry
  def self.add_entry(entry)
    unless exists? :guid => entry.id
      create!(
        :name     => entry.title,
        :summary    => entry.summary,
        :url      => entry.url,
        :published_at => entry.published,
        :guid       => entry.id
      )
    end
    begin
      Member.send_RSS(entry)
      #Twitter.update("[#{entry.published.strftime("%B %d, %Y")}][#{entry.title}] http://www.nolanotify.com/")
      Twitter.update("#{entry.title} (#{entry.published.strftime("%B %d, %Y")}) #{entry.url}")
    rescue
    end
  end

  # Testing purpose
  def self.update_from_feed_once_testing(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entry(feed.entries[0])
  end

end
