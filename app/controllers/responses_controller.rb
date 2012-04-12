class ResponsesController < ApplicationController

  #post /responses/receive_message
  def receive_message
    puts params
    if params[:session]
      puts params[:session]
    end
  end
end
