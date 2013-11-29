class Member < ActiveRecord::Base
  attr_accessible :number, :carrier
  validates :number, :carrier, :presence => true
  validates :number, :uniqueness => true
  validates :number, :numericality => { :only_integer => true }

  def self.send_RSS(entry)
  	carrier_codes = {	"Verizon" 		=> "vtext.com",
  						"AT&T"			=> "txt.att.net",
  						"T-Mobile"		=> "tmomail.net",
  						"Boost Mobile"	=> "myboostmobile.com",
  						"Sprint"		=> "messaging.sprintpcs.com",
  						"Virgin Mobile"	=> "vmobl.com"}
    amount = entry['total']['amount']
    currency = entry['total']['currency']
  	for memb in Member.all()
  		mail = Mail.deliver do
  		  to "#{memb.number}@#{carrier_codes[memb.carrier]}"
  		  from 'notifybitcoin@gmail.com'
  		  subject amount + " " + currency
  		  text_part do
  		    body "Profit Made: " + ((amount.to_f - 545.63)*2).round(2).to_s + " " + currency
  		  end
  		  html_part do
  		    content_type 'text/html; charset=UTF-8'
  		    body '<b>Hello world in HTML</b>'
  		  end
  		end
    end
  end

  def self.send_subscribed(number, carrier)
  	carrier_codes = {	"Verizon" 		=> "vtext.com",
  						"AT&T"			=> "txt.att.net",
  						"T-Mobile"		=> "tmomail.net",
  						"Boost Mobile"	=> "myboostmobile.com",
  						"Sprint"		=> "messaging.sprintpcs.com",
  						"Virgin Mobile"	=> "vmobl.com"}
	mail = Mail.deliver do
	  to "#{number}@#{carrier_codes[carrier]}"
	  from 'notifybitcoin@gmail.com'
	  subject 'You have been subscribed to Bitcoin Notify!'
	  text_part do
	    body "Please go to http://bitcoinnotify.herokuapp.com/ for details."
	  end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body '<b>Hello world in HTML</b>'
	  end
	end
	mail = Mail.deliver do
	  to ENV['JAY_EMAIL']
	  from 'notifybitcoin@gmail.com'
	  subject "NOLAnotify Subscribed:[#{number}]"
	  text_part do
	    body "[#{number}][#{carrier}]"
	  end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body "<b>[#{number}][#{carrier}]</b>"
	  end
	end
  end

  def self.send_unsubscribed(number, carrier)
  	carrier_codes = {	"Verizon" 		=> "vtext.com",
  						"AT&T"			=> "txt.att.net",
  						"T-Mobile"		=> "tmomail.net",
  						"Boost Mobile"	=> "myboostmobile.com",
  						"Sprint"		=> "messaging.sprintpcs.com",
  						"Virgin Mobile"	=> "vmobl.com"}
	mail = Mail.deliver do
	  to "#{number}@#{carrier_codes[carrier]}"
	  from 'notifybitcoin@gmail.com'
	  subject 'You have been unsubscribed from Bitcoin Notify!'
	  text_part do
	    body "Please go to http://bitcoinnotify.herokuapp.com/ for details."
	  end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body '<b>Hello world in HTML</b>'
	  end
	end
	mail = Mail.deliver do
	  to ENV['JAY_EMAIL']
	  from 'notifybitcoin@gmail.com'
	  subject "NOLAnotify Unsubscribed:[#{number}]"
	  text_part do
	    body "[#{number}][#{carrier}]"
	  end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body "<b>[#{number}][#{carrier}]</b>"
	  end
	end
  end

end
