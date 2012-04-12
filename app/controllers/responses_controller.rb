class ResponsesController < ApplicationController

  #post /responses/receive_message
  def receive_message
    puts params
    if params[:session]
      puts params[:session]
    end

    render :text=>"received", :status=>202

  end
end
