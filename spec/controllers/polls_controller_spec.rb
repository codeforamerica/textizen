require 'spec_helper'

describe PollsController do
  #, "#show" do
  before(:each) do
    #@current_user = login
    controller.stub(:get_new_phone_number).and_return("4443332222")
    @poll=FactoryGirl.create(:poll) #:user=>controller.current_user
  end
  

  # describe "authorization" do
  #   pending "all actions should be accessible to logged in users" do
  #   end
  # 
  #   describe "no actions should be accessible to non-logged-in users and should redirect to signin" do
  #     before(:each) do
  #       sign_out(@current_user)
  #     end
  # 
  #     it "on the show page should redirect to signin page" do
  #       get :show, {:id => @group.id}
  #       response.should redirect_to(new_user_session_path)
  #     end
  # 
  #     it "on the edit page should redirect to signin page" do
  #       get :edit, {:id => @group.id}
  #       response.should redirect_to(new_user_session_path)
  #     end
  # 
  #     it "on the index page should redirect to signin page" do
  #       get :index
  #       response.should redirect_to(new_user_session_path)
  #     end
  # 
  #     it "on the new page should redirect to signin page" do
  #       get :new
  #       response.should redirect_to(new_user_session_path)
  #     end
  #   end
  # 
  # end
  # 
  
  describe "#create" do
    # before :each do
    #   login
    # end
    it "after successful create, should redirect to show page" do
      controller.should_receive(:get_new_phone_number).and_return("5556667777")
      post :create, :poll=>{}
      assigns[:poll].should_not be_nil
      response.should redirect_to(assigns[:poll])
    end
  end
    
    # it "must belong to the logged in user" do
    #   post :create, :poll=>{}
    #   assigns[:poll].user.should == controller.current_user
    #   post :create, :poll=>{:user_id=>999}
    #   assigns[:poll].user.should == controller.current_user
    # end
  end
  
  describe "boilerplate stuff" do
    describe "index" do
      it "should set @polls" do
        get :index
        assigns[:polls].should_not be_nil
      end
      pending "should be limited to logged in users' polls only" do
      end
    end
    
    describe "show/edit" do
      it "should set @poll and a @page_title" do
        [:show,:edit].each do |meth|
          get meth, {:id=>@poll.id}
          assigns[:poll].should_not be_nil
          assigns[:page_title].should_not be_nil
        end
      end
    end
  # it "must belong to the logged in user" do
  #   post :create, :group=>{}
  #   assigns[:group].user.should == controller.current_user
  #   post :create, :group=>{:user_id=>999}
  #   assigns[:group].user.should == controller.current_user
  # end
end
