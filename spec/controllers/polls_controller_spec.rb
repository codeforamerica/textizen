require 'spec_helper'

describe PollsController do
  context "logged-in user" do
    login_user

    #, "#show" do
    before(:each) do
      @poll = FactoryGirl.create(:poll, :author => subject.current_user ) #:user=>controller.current_user
    end

    describe "GET new" do
      it "assigns @poll" do
        get :new
        assigns[:poll].should_not be_nil
      end

      it "has a 200 status code" do
        get :new
        response.code.should == "200"
      end
    end

    describe "POST create" do
      it "redirects to the show page after successful create" do
        post :create, :poll=> FactoryGirl.attributes_for(:poll)
        assigns[:poll].should_not be_nil # :poll should exist
        response.should redirect_to(assigns[:poll])
      end
    end

    describe "PUT update" do
      context "valid params" do
        it "redirects to poll page" do
          put :update, :id => @poll.id, :poll => { :title => "Where my groceries at?" }
          response.should redirect_to(@poll)
        end
      end
    end

    describe "DELETE destroy" do
      it "redirects to poll index page" do
        delete :destroy, :id => @poll.id
        response.should redirect_to(polls_path)
      end
    end

    describe "#end" do
      it "should end a running poll" do
        @poll.running?.should be_true
        put :end, {:id=>@poll.id}
        response.should redirect_to(@poll)
        Poll.last.running?.should be_false
      end
    end


    describe "GET index" do
      it "should set @polls" do
        get :index
        assigns[:polls].should_not be_nil
      end
    end

    describe "#show/edit" do
      it "should set @poll and a @page_title" do
        [:show,:edit].each do |meth|
          get meth, {:id=>@poll.id}
          assigns[:poll].should_not be_nil
        end
      end
    end

    describe "GET clear_responses" do
      it "removes responses for a poll" do
        poll = FactoryGirl.create(:question_with_responses, :poll => @poll)
        poll.responses.count.should > 0

        get :clear_responses, :id => @poll.id

        poll.responses.count.should == 0
      end

      it "redirects to poll page" do
        get :clear_responses, :id => @poll.id

        response.should redirect_to(@poll)
      end
    end

    describe "PUT publish" do
      context "unpublished poll" do
        it "publishes the selected poll" do
          @poll.update_attribute(:public, true)
          put :publish, :id => @poll.id

          @poll.public.should be_true
        end
      end

      context "published poll" do
        it "unpublishes the poll" do
          put :publish, :id => @poll.id

          @poll.public.should be_false
        end
      end

      it "redirects to show page if save is successful" do
        put :publish, :id => @poll.id

        response.should redirect_to(@poll)
      end
    end

    context "logged in superadmin" do
      before do
        subject.current_user.role = "superadmin"
        subject.current_user.save
      end

      describe "GET index" do
        it "returns all polls if they exist" do
          poll = FactoryGirl.create(:poll)
          get :index
          assigns(:polls).should == Poll.all
        end
      end
      
      describe "POST create" do

      end
    end

  end
end
