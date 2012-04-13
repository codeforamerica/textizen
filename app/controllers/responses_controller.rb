class ResponsesController < ApplicationController

  #post /responses/receive_message
  def receive_message
    puts session = Tropo::Generator.parse params

    # puts params
    # if params[:session]
    #   puts params[:session]
    # end
    # # if params[:session][:to][:network] == "IM" #debug mode
    # @to = params[:session]['to']['id']
    # @from = params[:session]['from']['id']
    # @poll = get_poll_by_phone(@from)

#      10.times { p.responses.create(:from => '1'+rand(10 ** 9).to_s, :to => p.phone, :response => 'I buy groceries IN YOUR FACE') }


    render Tropo::Generator.say "hi"
  end

  # reject the message
  def reject(message)
    return Tropo::Generator.say "Sorry, invalid input"
  end

  def get_poll_by_phone(phone)
    return Poll.where(:phone=>phone)[0]
  end

  def normalize_phone(phone)
    unless phone.match(/^\+/)
      phone = "+" + phone
    end
    return phone
  end
end
