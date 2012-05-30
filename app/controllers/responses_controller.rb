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
      if @poll.running? #if the poll is running
        puts "poll running"
        if @poll.questions.length > 0 #and has questions
          @poll.questions_ordered.each do |q|
            if !q.answered?(@from) #and has no responses from this person
              puts "no previous responses to question"
              if q.valid_response?(@response) #make sure it's  valid response
                puts "valid response, creating new response"
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
              puts "previous response detected and follow-up triggered but not answered"
              q.get_follow_up.responses.create(from: @from, response: @response)
              send_next_question_or_thanks(@poll, @from)
              return
            else
              puts "question already answered by this person"
            end
          end
          puts "all questions answered?"
        else
          puts "poll has no questions"
          error "poll has no questions"
        end
        puts "end of active poll tree"

        #@response = @poll.responses.create(:from => @from, :response => @response)
        #puts "response created"
      else 
        reject("poll is not active")
        puts "poll inactive"
      end
    else
      puts "poll not found"
      reject("poll not found")
    end
  end

  # sends the next question in the poll, or says thanks
  def send_next_question_or_thanks(poll, from)
    qnext = poll.get_next_question(from)
    if qnext
      puts 'sending next question'
      send_question(qnext)
    else
      say("Thank you for responding to our poll on %s. More info: phila2035.org" % @poll.title)
    end
  end
  
  def send_question(q)
    say(q.to_sms)
  end

  def send_follow_up(q)
    say("Follow-up question: %s" % q.get_follow_up.to_sms)
  end

  def say(message)
    puts "say %s" % message
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
