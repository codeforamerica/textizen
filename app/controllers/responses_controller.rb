class ResponsesController < ApplicationController
  #post /responses/receive_message
  
  def receive_message
    @session = Tropo::Generator.parse params
    
    # if params[:session][:to][:network] == "IM" #debug mode
    @to = @session[:session][:to][:id]
    @from = @session[:session][:from][:id]
    
    @poll = Poll.get_poll_by_phone(@to)
    logger.debug "Poll: #{@poll}"

    @response = @session[:session][:initial_text]
    logger.debug "response "+@response

    if @poll
      if @poll.running? #if the poll is running
        logger.debug "poll running"
        if @poll.questions.length > 0 #and has questions
          @poll.questions.in_order.each do |q|
            if !q.answered?(@from) #and has no responses from this person
              if q.valid_response?(@response) #make sure it's  valid response
                logger.debug "valid response, creating new response"
                q.responses.create(from: @from, response: @response)
                if q.send_follow_up?(@response)
                  send_follow_up(q)
                else
                  send_next_question_or_thanks(@poll, @from)
                end
                return
              else
                reject('invalid response')
                return
              end
            elsif q.get_follow_up && !q.get_follow_up.answered?(@from) && q.follow_up_triggered?(@from)
              logger.debug "previous response detected and follow-up triggered but not answered"
              q.get_follow_up.responses.create(from: @from, response: @response)
              send_next_question_or_thanks(@poll, @from)
              return
            end
          end
        end
      else
        reject("poll is not active")
      end
    else
      reject("poll not found")
    end
  end

  # sends the next question in the poll, or says thanks
  def send_next_question_or_thanks(poll, from)
    qnext = poll.get_next_question(from)
    if qnext
      send_question(qnext)
    else
      say(poll.confirmation || "Thank you for responding to our poll on %s." % @poll.title)
    end
  end
  
  def send_question(q)
    say(q.to_sms)
  end

  def send_follow_up(q)
    say("%s" % q.get_follow_up.to_sms)
  end

  def say(message)
    render :text => (Tropo::Generator.say message)
  end

  # reject the message
  def reject(message)
    say("Sorry, %s" % message)
  end

  def error(message)
    reject("there is something wrong with this poll, please try again soon")
    raise "poll error: %s" % message
  end

end
