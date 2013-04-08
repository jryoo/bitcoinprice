desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  FeedEntry.update_from_feed("http://www.swbno.org/rss.asp?feed=pr")
  puts "done."
end

#task :send_reminders => :environment do
#  User.send_reminders
#end