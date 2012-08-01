(function(){
  var labelLength = 2;
  var paddingLength = 3;

  var CharCounter = function(node){
    this.node = $(node);

    this.refreshInputs = function(){

      this.inputs = inputsForQuestion(node);
      console.log('inputs:');
      console.log(this.inputs);
    }
    this.refreshInputs();

    this.node.bind('keyup', {counter: this}, function(event){
      console.log("keyup");
      console.log(event.target);
      event.data.counter.refreshInputs();
      var l = messageLength(event.data.counter.inputs);
      this.valid = (l <= 160);
      console.log("MESSAGE LENGTH: "+l+" VALID?: "+this.valid);
      // do DOM stuff
    });
  }

  $.fn.charCounter = function(){
    this.each(function(index, item){
      console.log(item);
      new CharCounter(item);
    });
  };

  function inputsForQuestion(question){
    question = $(question);
    console.log('inputsForQuestion:');
    console.log(question);
    if (question.hasClass('confirmation')){
      return $(question);
    } else {
      var inputs = question.find('textarea,select,input:visible');
      console.log(inputs);
      return $(inputs);
      // if confirmation, inputs = [confirmation]
      // if open ended or yes/no question inputs = [question, type]
      // if multi inputs = [question, type, options]

    }
  }
  // returns the message length for a set of inputs
  function messageLength(inputs){
    console.log('messageLength');
    console.log(inputs);
    var count = inputs[0].value.length; // the question text, or the confirmation 
    if (inputs.length > 1){ //won't fire if only confirmation
      var questionType = inputs[1].value;
      count += textForQuestionType(questionType);
    }
    if (inputs.length > 2){ // we have options
      count += inputs.length * labelLength;
      count += (inputs.length - 1) * paddingLength;
      inputs.each(function(input){
        count += input.value ? input.value.length : 0;
      });
    }

    return count;
  }
  // returns the additional text to be counted for each question type
  function textForQuestionType(questionType){
    switch (questionType) {
      case 'YN':
        return 'Reply with Yes or No'.length;
      case 'MULTI':
        return 'Reply with letter: '.length;
      default:
        return 0;
    }
  }
})();

$(document).ready(function(){
  /************* char counter stuff ******************/
  $('.question-entry').charCounter();
  $('.confirmation').charCounter();
  $(document).on('insertion-callback', function(event){
    // figure out if it was a question
    // or a followup question
    
//    $(event.target).charCounter();
    // or an option
    // or a followup option

//    $(event.target).getParentQuestion().optionAdded();

  });

  /********* form editing stuff ********************/
  // form editing stuff
  if (typeof initEditing === 'undefined') {
    initEditing = false;
  }
  var alphabet = ['A','B','C','D','E','F','G'];

  // Javascript that fills out value tag when label is filled out

  // TODO THIS BREAKS!
  $(document).on("click", "a.add-followup-dummy", function(event){
    $(this).parents(".option-field").find(".add-followup-button").click();
    $(this).parents(".question-entry").addClass("has-followup");
    event.preventDefault();
  });

  // recalculate all form values
  $(".item-container").on("insertion-callback after-removal-callback", ".question-entry", function (event){
    var entry = $(this);

    if (entry.find(".followup-field").length === 0 || entry.find(".followup-field").is(":hidden")){ // second piece is for deleted followups when editing an existing poll
      entry.removeClass("has-followup");
    } else {
      entry.addClass("has-followup");
    }
    // make sure this is not a yes/no question
    if (entry.find("select.question-type").val() == "MULTI"){
      // loop through each option text input
      entry.find(".option-text").each(function(i,el){
        // surround each text input with a nice bootstrappy prepend thing
        if (!$(el).hasClass("prepended")){
          $(el).addClass("prepended");
          $(el).before('<div class="input-prepend"><span class="add-on option-add-on"></span>').after('</div>');
        }

        if (i == 6){
          $(".add-option-button").hide();
        } else if (i == 5){
          $(".add-option-button").show();
        }
      });

      // refresh all prepended label values
      entry.find(".option-field .option-add-on").each(function(i, el){
        $(el).text(alphabet[i]);
      });
      // refresh all hidden value inputs
      entry.find(".option-field .option-value").each(function(i, el){
        $(el).val(alphabet[i]);
      });
    }
    if (entry.find("select.followup-type").val() == "MULTI"){
      entry.find(".followup-option-text").each(function(i,el){

        if (!$(el).hasClass("prepended")){
          $(el).addClass("prepended");
          $(el).before('<div class="input-prepend"><span class="add-on followup-add-on"></span>').after('</div>');
        }

        if (i == 6){
          entry.find(".add-followup-option-button").hide();
        } else if (i == 5){
          entry.find(".add-followup-option-button").show();
        }
      });

      // refresh all prepended label values
      entry.find(".followup-option-field .followup-add-on").each(function(i, el){
        $(el).text(alphabet[i]);
      });

      entry.find(".followup-option-field .followup-option-value").each(function(i, e){
        $(e).val(alphabet[i]);
      });
    }
  });

  // Autofills the options form when a question type is selected 
  $(".simple_form").on("change", "select.question-type", function(event) {

    // Wipes existing options TODO: hide, instead of remove?

    if (!initEditing){
      $(this).parents(".nested-fields").find(".option-field").remove();
    }
    $(this).parents(".question-entry").removeClass("has-followup");

    var value = $(this).val();

    var parent_container_entry = $(this).parents(".question-entry");
    parent_container_entry.find(".add-option-button").hide();	


    if (value == "YN") {
      
      if (!initEditing){
        // Clicks the add_option button twice
        parent_container_entry.find(".add-option-button").click();
        parent_container_entry.find(".add-option-button").click();	
      }
      // Pre-fills out information, sets class to disabled
      parent_container_entry.find(".option-field .option-text").first().addClass("disabled yes-no").val("Yes");
      parent_container_entry.find(".option-field .option-value").first().addClass("disabled yes-no").val("yes");
      parent_container_entry.find(".option-field .option-text").last().addClass("disabled yes-no").val("No");
      parent_container_entry.find(".option-field .option-value").last().addClass("disabled yes-no").val("no");

      // Removes "remove option" button
      parent_container_entry.find(".help-inline a.remove_fields").hide();
    }
    else if (value == "MULTI") {
      // Show "add option" button
      parent_container_entry.find(".add-option-button").show();

      if (!initEditing){
        // Clicks the add_option button twice 
        parent_container_entry.find(".add-option-button").click();
        parent_container_entry.find(".add-option-button").click();
      }
    }
    else if (value == "OPEN") {
    }
  });

  // This is the
  $(".simple_form").on("change", "select.followup-type", function(event) {

    // Wipes existing options TODO: hide, instead of remove?
    
    if (!initEditing){ // make sure it's not just the /edit UI refresh
      $(this).parents(".nested-fields").find(".remove-follow-up-option").click();
    }

    var value = $(this).val();

    var parent_container_entry = $(this).parents(".followup-field");
    parent_container_entry.find(".add-followup-option-button").hide();	

    if (value == "YN") {
      if (!initEditing){
        // Clicks the add_option button twice
        parent_container_entry.find(".add-followup-option-button").click();
        parent_container_entry.find(".add-followup-option-button").click();	
      }
      // Pre-fills out information, sets class to disabled
      parent_container_entry.find(".followup-option-field .followup-option-text").first().addClass("disabled yes-no").val("Yes");
      parent_container_entry.find(".followup-option-field .followup-option-text").last().addClass("disabled yes-no").val("No");

      parent_container_entry.find(".followup-option-field .followup-option-value").first().addClass("disabled yes-no").val("yes");
      parent_container_entry.find(".followup-option-field .followup-option-value").last().addClass("disabled yes-no").val("no");
      // Removes "remove option" button
//      parent_container_entry.find(".followup-option-field a.remove_fields").hide();
    }
    else if (value == "MULTI") {
      // Show "add option" button
      parent_container_entry.find(".add-followup-option-button").show();	
      
      if (!initEditing){
        // Clicks the add_option button twice 
        parent_container_entry.find(".add-followup-option-button").click();
        parent_container_entry.find(".add-followup-option-button").click();
      }
    }
    else if (value == "OPEN") {
    }
  });
});
