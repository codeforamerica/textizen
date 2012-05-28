Hey, love the library, but having some issues with nesting on [this project](https://github.com/codeforamerica/textyourcity/tree/followups-simpleform)
Don't think it's necessarily an issue with the library, but my head is spinning so thought I'd post in case you had any ideas!

Here's the hierarchy:

[Poll](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/models/poll.rb) ([form](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/views/polls/_form.html.erb)) `has_many` [Questions](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/models/question.rb) ([form](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/views/polls/_question_fields.html.erb)) `has_many` [Options](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/models/option.rb) ([Form](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/views/polls/_option_fields.html.erb)) `has_one` Follow-up, class: Question ([Form](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/views/polls/_follow_up_fields.html.erb)) `has_many` Options ([Form](https://github.com/codeforamerica/textyourcity/blob/followups-simpleform/app/views/polls/_follow_up_option_fields.html.erb))

UI renders fine, but issues arise editing objects with followups, or creating items with follow-up-options (the two deepest levels of nesting)

#### 1-  The most serious issue, When creating a poll: Unable to create more than one follow-up option. Everything looks fine in the UI, but only one follow-up-option gets posted and saved
  
  When attempting to create a poll with the following structure
  	
		Question, text: "First question" type "MULTI" 
			option, label: apples, value: a
			option, label: bananas, value: b
				Follow-up question, text: "Are you sure?", type: "YN"
					option: yes
					option: no
		
This is what gets `post`ed
  
		Started POST "/polls" for 127.0.0.1 at 2012-05-24 18:42:07 -0700
		Processing by PollsController#create as HTML
		Parameters: {
		   "utf8"   =>"✓",
		   "authenticity_token"   =>"geW3nvwDaEftZyJUaAkmb69iD0aJJe/WT1/ynV+pl+M=",
		   "poll"   =>   {
		      "questions_attributes"      =>      {
		         "1337909867131"         =>         {
		            "text"            =>"First question",
		            "_destroy"            =>"",
		            "question_type"            =>"MULTI",
		            "options_attributes"            =>            {
		               "1337909878928"               =>               {
		                  "text"                  =>"apples",
		                  "_destroy"                  =>"",
		                  "value"                  =>"a"
		               },
		               "1337909884148"               =>               {
		                  "text"                  =>"bananas",
		                  "_destroy"                  =>"",
		                  "value"                  =>"b",
		                  "follow_up_attributes"                  =>                  {
		                     "text"                     =>"Are you sure?",
		                     "question_type"                     =>"YN",
		                     "_destroy"                     =>"",
		                     "options_attributes"                     =>                     {
		                        "1337909884148"                        =>                        {
		                           "text"                           =>"no",
		                           "value"                           =>"n",
		                           "_destroy"                           =>""
		                        }
		                     }
		                  }
		               }
		            }
		         }
		      },
			  ... snip...
		}	  


#### 2-  When editing: Can't edit any poll that has follow-ups. When attempting to edit, it seems follow-ups are being deleted. In the below log, questions_all graps all the questions for a poll, including for any followups
  
Check this out

	  1.9.3p125 :187 > Poll.find(57).questions_all
	   => [#<Question id: 72, text: "where?", poll_id: 57, question_type: "OPEN", created_at: "2012-05-24 22:51:15", updated_at: "2012-05-24 22:51:15", sequence: nil, parent_option_id: nil>, #<Question id: 70, text: "yes or no?", poll_id: 57, question_type: "OPEN", created_at: "2012-05-24 22:51:15", updated_at: "2012-05-25 01:23:36", sequence: nil, parent_option_id: nil>, #<Question id: 73, text: "aaaaa", poll_id: nil, question_type: "OPEN", created_at: "2012-05-25 01:23:36", updated_at: "2012-05-25 01:23:36", sequence: nil, parent_option_id: 55>] 

	  1.9.3p125 :188 > Poll.find(57).options_all
	   => [#<Option id: 55, text: "yes", question_id: 70, value: "yes", follow_up_id: nil, created_at: "2012-05-24 22:51:15", updated_at: "2012-05-24 22:51:15">, #<Option id: 56, text: "no", question_id: 70, value: "no", follow_up_id: nil, created_at: "2012-05-24 22:51:15", updated_at: "2012-05-24 22:51:15">] 

	  polls/57/edit with no changes, just hit "update"
	
		ActiveRecord::RecordNotFound in PollsController#update

		Couldn't find Question with ID=73 for Option with ID=55

	  then...

	  1.9.3p125 :189 > reload!
	  Reloading...
	   => true 
	  1.9.3p125 :190 > Poll.find(57).questions_all
	   => [#<Question id: 72, text: "where?", poll_id: 57, question_type: "OPEN", created_at: "2012-05-24 22:51:15", updated_at: "2012-05-24 22:51:15", sequence: nil, parent_option_id: nil>, #<Question id: 70, text: "yes or no?", poll_id: 57, question_type: "OPEN", created_at: "2012-05-24 22:51:15", updated_at: "2012-05-25 01:23:36", sequence: nil, parent_option_id: nil>] 
	  1.9.3p125 :191 > Question.find(73)
	    Question Load (0.7ms)  SELECT "questions".* FROM "questions" WHERE "questions"."id" = $1 LIMIT 1  [["id", 73]]
	  ActiveRecord::RecordNotFound: Couldn't find Question with id=73
	  

I'm pretty much out of ideas, my next step was to create a separate follow-ups table (or try using Single Table Inheritance to emulate it) and see if that fixed anything...
Thanks again!



updates:

Some updates. 

For issue #2. If I remove `:dependent => :destroy` from the `Option has_one follow-up` relationship I get this error. _option_fields.html.erb:11 is "link_to_add_association :follow_up"

		ActiveRecord::RecordNotSaved in PollsController#edit

		Failed to remove the existing associated follow_up. The record failed to save when after its foreign key was set to nil.
		Rails.root: /Users/ayule/code/txtyourcity_rails

		Application Trace | Framework Trace | Full Trace
		app/views/polls/_option_fields.html.erb:11:in `_app_views_polls__option_fields_html_erb___3590358424531303420_70248388674980'

Seems the issue is due to follow_up being a `has_one` relationship. Upon editing, `link_to_add_association` tries to destroy the follow_up (if able).
Everything seems to work fine once I switch it to a `has_many`. So I guess this becomes a feature request for support of has_one relationships!

Issue #1 is still unresolved... if it would be helpful I could spin up a demo instance of the app and send over the link!