# A Tropo 'scripting API' app - this runs on Tropo's servers
# handles inbound/outbound sessions: https://www.tropo.com/docs/rest/starting_session.htm

require 'rubygems'
require 'json'
require 'net/http'

def send(message, numbers, from)
    log("sending '#{message}' to #{numbers} from #{from}")
    message(message, {
      :to => numbers,
      :network => "SMS",
      :callerID => from
    })
end

outbound = $message ? true : false

if outbound
  # send sms out to the group
  msg = $message
  numbers = $numbers
  from = $callerId
	numbers = numbers.split(',')
	send(msg,numbers,from)
else
  # send incoming texts to our server
  Net::HTTP.post_form( 
	URI.parse("http://textyourcity.herokuapp.com/polls/receive_message"), {
			:message => $currentCall.initialText,
			:incoming_number => $currentCall.calledID,
			:origin_number => $currentCall.callerID
		}
	)
end