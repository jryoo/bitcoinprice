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
end
