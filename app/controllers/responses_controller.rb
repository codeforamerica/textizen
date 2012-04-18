class ResponsesController < ApplicationController
  #post /responses/receive_message
  
  def receive_message
    puts params
    @session = Tropo::Generator.parse params
    puts @session

    
    # if params[:session][:to][:network] == "IM" #debug mode
    @to = @session[:session][:to][:id]
    @from = @session[:session][:from][:id]
    
    @poll = get_poll_by_phone(@to)
    puts "poll"
    puts @poll

    @response = @session[:session][:initial_text]
    puts "response "+@response

    if @poll
      puts "poll found"
      @response = @poll.responses.create(:from => @from, :response => @response)
      puts "response created"
      render :text => say("Thank you for you for responding to our poll on %s. Your response has been recorded." % @poll.title)
    else
      puts "poll not found"
      render :text => reject("poll not found")
    end
  end

  def say(message)
    puts "say %s" % message
    return (Tropo::Generator.say message)
  end

  # reject the message
  def reject(message)
    return say("Sorry, %s" % message)
  end

  def get_poll_by_phone(phone)
    puts ("finding poll " + phone)
    return Poll.where(:phone=>phone)[0]
  end

end
