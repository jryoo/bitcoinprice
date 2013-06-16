class Member < ActiveRecord::Base
  attr_accessible :number, :carrier
  validates :number, :carrier, :presence => true
  validates :number, :uniqueness => true
  validates :number, :numericality => { :only_integer => true }

  def self.send_RSS(message)
  	carrier_codes = {	"Verizon" 		=> "vtext.com",
  						"AT&T"			=> "txt.att.net",
  						"T-Mobile"		=> "tmomail.net",
  						"Boost Mobile"	=> "myboostmobile.com",
  						"Sprint"		=> "messaging.sprintpcs.com",
  						"Virgin Mobile"	=> "vmobl.com"}
  	for memb in Member.all()
  		mail = Mail.deliver do
  		  to "#{memb.number}@#{carrier_codes[memb.carrier]}"
  		  from 'nolaswnotice@gmail.com'
  		  subject message.title
  		  text_part do
  		    body message.id
  		  end
  		  html_part do
  		    content_type 'text/html; charset=UTF-8'
  		    body '<b>Hello world in HTML</b>'
  		  end
  		end
    end
  end

  def self.send_RSS_test(message)
    carrier_codes = { "Verizon"     => "vtext.com",
              "AT&T"      => "txt.att.net",
              "T-Mobile"    => "tmomail.net",
              "Boost Mobile"  => "myboostmobile.com",
              "Sprint"    => "messaging.sprintpcs.com",
              "Virgin Mobile" => "vmobl.com"}
    mail = Mail.deliver do
      to "#{ENV['TEST_NUMBER']}@#{carrier_codes[ENV['TEST_CARRIER']]}"
      from 'nolaswnotice@gmail.com'
      subject message.title
      text_part do
        body message.id
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body '<b>Hello world in HTML</b>'
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
	  from 'nolaswnotice@gmail.com'
	  subject 'You have been subscribed to NOLA Notify!'
	  text_part do
	    body "Please go to http://www.nolanotify.com for details."
	  end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body '<b>Hello world in HTML</b>'
	  end
	end
	mail = Mail.deliver do
	  to ENV['JAY_EMAIL']
	  from 'nolaswnotice@gmail.com'
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
	  from 'nolaswnotice@gmail.com'
	  subject 'You have been unsubscribed from NOLA Notify!'
	  text_part do
	    body "Please go to http://www.nolanotify.com for details."
	  end
	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body '<b>Hello world in HTML</b>'
	  end
	end
	mail = Mail.deliver do
	  to ENV['JAY_EMAIL']
	  from 'nolaswnotice@gmail.com'
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
