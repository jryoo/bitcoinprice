class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :name, :published_at, :summary, :url
  def self.update_from_feed(feed_url)
  	feed = Feedzirra::Feed.fetch_and_parse(feed_url)
  	add_entries(feed.entries)
  end

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
        Member.send_RSS(entry)
  		end
  	end
  end

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
    Member.send_RSS(entry)
  end

  def self.update_from_feed_once_testing(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entry(feed.entries[0])
  end

end
