require 'spec_helper'

describe PollsController do
  #, "#show" do
  before(:each) do
    @poll=FactoryGirl.create(:poll) #:user=>controller.current_user
  end
  
  describe "#create" do
    it "after successful create, should redirect to show page" do
      post :create, :poll=> FactoryGirl.attributes_for(:poll)
      assigns[:poll].should_not be_nil # :poll should exist
      response.should redirect_to(assigns[:poll])
    end
  end
  
  describe "boilerplate stuff" do
    describe "index" do
      it "should set @polls" do
        get :index
        assigns[:polls].should_not be_nil
      end
    end
  end
    
  describe "show/edit" do
    it "should set @poll and a @page_title" do
      [:show,:edit].each do |meth|
        get meth, {:id=>@poll.id}
        assigns[:poll].should_not be_nil
      end
    end
  end

end
