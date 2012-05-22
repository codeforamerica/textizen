class ResponsesController < ApplicationController
  #post /responses/receive_message
  
  def receive_message
    puts params
    @session = Tropo::Generator.parse params
    puts @session
    
    # if params[:session][:to][:network] == "IM" #debug mode
    @to = @session[:session][:to][:id]
    @from = @session[:session][:from][:id]
    
    @poll = Poll.get_poll_by_phone(@to)
    puts "poll"
    puts @poll

    @response = @session[:session][:initial_text]
    puts "response "+@response

    if @poll
      puts "poll found"
      if @poll.running?
        if @poll.questions.length > 1
          @poll.questions_ordered.each do |q|
            if !q.responses.where(:phone => @from)
              if q.validate_response?(@response)
                q.responses.create(phone: @from, response: @response)
              end
              # no responses yet for this question from this person
            elsif q.get_follow_up && q.follow_up_triggered
              q.get_follow_up.responses.create(phone: @from, response: @response)
              return
            end
          end
        else
          puts "poll has no questions"
          error
        end

        #@response = @poll.responses.create(:from => @from, :response => @response)
        #puts "response created"
        #say("Thank you for responding to our poll on %s. Your response has been recorded." % @poll.title)
      else 
        reject("poll is not active")
      end
    else
      puts "poll not found"
      reject("poll not found")
    end
  end

  def say(message)
    puts "say %s" % message
    render :text => (Tropo::Generator.say message)
  end

  # reject the message
  def reject(message)
    return say("Sorry, %s" % message)
  end

  def error
    reject("there is something wrong with this poll")
  end

end
