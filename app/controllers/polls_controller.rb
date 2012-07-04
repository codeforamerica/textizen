class PollsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /polls
  # GET /polls.json
  def index
    if current_user.role?(:superadmin) # TODO: transfer this to cancan syntax, eventually
      @polls = Poll.all
    else
      @polls = current_user.polls + current_user.created_polls 
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @polls }
    end
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
    @poll = Poll.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @poll }
      format.csv { export_to_csv }
    end
  end

  # GET /polls/new
  # GET /polls/new.json
  def new
    @poll = Poll.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @poll }
    end
  end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(params[:poll])
    @poll.author = current_user

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render json: @poll, status: :created, location: @poll }
      else
        puts @poll.errors.full_messages
        format.html { render action: "new" }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /polls/1
  # PUT /polls/1.json
  def update
    @poll = Poll.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { head :no_content }
      else
        puts @poll.errors.full_messages
        format.html { render action: "edit" }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to polls_url }
      format.json { head :no_content }
    end
  end

  # PUT /polls/1/end
  def end
    @poll = Poll.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes({:end_date=> Time.now})
        format.html { redirect_to @poll, notice: 'Poll was successfully ended.' }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
    #flash[:notice] = "ended poll"
  end

  def export_to_csv
    send_data @poll.to_csv,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=poll#{@poll.id}.csv"
  end

end
