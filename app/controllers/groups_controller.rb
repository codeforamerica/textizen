class GroupsController < ApplicationController
  load_and_authorize_resource
  # GET /groups
  # GET /groups.json
  def index
    if current_user.role?(:superadmin) # TODO use a cancan ability here instead
      @groups = Group.all
    else
      @grups = current_user.groups
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @editing = true
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      errors = []
      if (emails=params[:user_emails])
        errors = @group.save_users_by_emails(emails)
      end
      @group.users << current_user if errors.empty?
      if errors.empty? and @group.save
        format.html { redirect_to edit_group_path(@group), notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        @group.errors.add(:users, errors)
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      errors = []
      if (emails=params[:user_emails])
        errors = @group.save_users_by_emails(emails)
      end

      if errors.empty? and @group.update_attributes(params[:group]) 
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else 
        @group.errors.add(:users, errors)
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
end
