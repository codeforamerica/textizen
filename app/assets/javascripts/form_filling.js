$(document).ready(function(){

  // char counter vars
  var separator = " / ";
  var alphabet = ['A','B','C','D','E','F','G'];
  var submitBtn = $('input[type=submit]');

  // CharCounter object to be created for each instance of a char counter
  var CharCounter = function(node){
    this.node = $(node); // the question/confirmation node with child inputs to count
    this.msgPreviewNode = $(this.node.find('.msg-preview')[0]); // the node to put the preview stuff
    this.countNode = $(this.node.find('.msg-count')[0]);
    this.errorNode = $(this.node.find('.msg-count-error')[0]);

    this.refreshInputs = function(){
      this.inputs = inputsForQuestion(node); // call this to pull in any newly added options
    };

    // validate the form, checking we're not over 160 and toggling the proper error classes
    this.validate = function(){
      var message = this.message();
      this.valid = message.length <= 160;
      if (this.valid){
        //this.node.find('.control-group').removeClass('error');
        this.countNode.removeClass('error');
        submitBtn.attr('disabled', false);
        submitBtn.removeClass('disabled');
        this.node.removeClass('count-error');
        this.errorNode.hide();
      } else {
        //this.node.find('.control-group').addClass('error');
        this.countNode.addClass('error');
        submitBtn.attr('disabled', true);
        submitBtn.addClass('disabled');
        this.node.addClass('count-error');
        this.errorNode.show();
      }
      //console.log("VALIDATE! "+this.valid);
      if (this.msgPreviewNode){
        this.msgPreviewNode.html(message);
      }

      if (this.countNode){
        this.countNode.html("<span class='msg-count-status'>" + message.length + "</span>/160");
      }

    };

    // construct the sms messsage from any child inputs
    this.message = function(){
      var message = "";
      //console.log(this.inputs);
      message += this.inputs[0].value; // the question text, or the confirmation 
      if (this.inputs.length > 1){ //won't fire if only confirmation
        var questionType = this.inputs[1].value;
        message += textForQuestionType(questionType);

        if (this.inputs.length > 2 && questionType != "YN"){ // we have options
          //console.log("OPTIONS!");
          var options = this.inputs.splice(2);
          options = $.map(options, function(item, index){
            return alphabet[index] + ' ' + item.value;
          });
          options = options.join(separator);
          //console.log("OPTIONS: "+options);
          message += options;
        }
      }
      //console.log(message);
      return message;

    };

    this.refreshInputs();

    // setup event handlers to count updates when ui changes
    this.node.on('keyup change removal-callback insertion-callback', {counter: this}, function(event){
      event.data.counter.refreshInputs();
      event.data.counter.validate();
    });

    // mark as counting so we don't add another char counter
    this.node.removeClass('counting');
  };


  /******** SMS COUNTER ************/
  $.fn.charCounter = function(){
    this.each(function(index, item){
      //      console.log(item);
      new CharCounter(item);
    });
  };

  function inputsForQuestion(question){
    question = $(question);
    //console.log('inputsForQuestion:');
    if (question.hasClass('confirmation')){
      return $(question).find('textarea');
    } else if (question.hasClass('question-entry')){
      return $(question.find('.question-input,.question-type,.option-text:visible'));
      // if confirmation, inputs = [confirmation]
      // if open ended or yes/no question inputs = [question, type]
      // if multi inputs = [question, type, options]

    } else {
      return $(question.find('.followup-input,.followup-type,.followup-option-text:visible'));
    }
  }
  // returns the message length for a set of inputs
  // returns the additional text to be counted for each question type
  function textForQuestionType(questionType){
    switch (questionType) {
      case 'YN':
        return ' Reply with Yes or No';
      case 'MULTI':
        return ' Reply with letter: ';
      default:
        return '';
    }
  }
  // function to call to add charCounter to any non-counted questions, excluding the first
  function refreshQuestionCounters(){

    $($('.question-entry.not-counted').splice(1)).charCounter();
    $('.followup-field.not-counted').charCounter();
  }


  /************* events ********************************/
  $(document).on('insertion-callback', function(event){
    //console.log('insertion');
    //console.log(event.target);
    refreshQuestionCounters();
  });


  // Javascript that fills out value tag when label is filled out

  $(document).on("click", "a.add-followup-dummy", function(event){
    $(this).parents(".option-field").find(".add-followup-button").click();
    $(this).parents(".question-entry").addClass("has-followup");
    event.preventDefault();
  });

  // recalculate all form values
  // this fires whenever a followup is added or removed
  $(".item-container").on("insertion-callback after-removal-callback", ".question-entry", function (event){


    var entry = $(this);

    if (entry.find(".followup-field:visible").length === 0){ // second piece is for deleted followups when editing an existing poll
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
      var visibleCount = 0;
      var optionValues = entry.find(".option-field .option-value");
      entry.find(".option-field .option-add-on").each(function(i, el){
        el = $(el);
        if (el.is(':visible')){
          var letter = alphabet[visibleCount++];
          el.text(letter);
          $(optionValues[i]).val(letter);
        }
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

      // refresh all prepended labels, and option values
      var followupVisibleCount = 0;
      var followupOptionValues = entry.find(".followup-option-field .followup-option-value");
      entry.find(".followup-option-field").each(function(i, el){
        el = $(el);
        if (el.is(':visible')){
          var addon = el.find(".followup-add-on");
          var letter = alphabet[followupVisibleCount++];
          //console.log("element "+i+" is visible");
          addon.text(letter);
          //console.log(followupOptionValues[i].value);
          $(followupOptionValues[i]).val(letter);
          //console.log(followupOptionValues[i].value);
        } else {
          //console.log('invisible');
        }
      });
    }
  });

  // Autofills the options form when a question type is selected 
  $(".simple_form").on("change", "select.question-type", function(event) {

    // Wipes existing options TODO: hide, instead of remove?

    var parent_container_entry = $(this).parents(".question-entry");

    if (!initEditing){
      parent_container_entry.find(".help-inline a.remove_fields").click(); // remove existing options using the remove field button
    }
    $(this).parents(".question-entry").removeClass("has-followup");

    var value = $(this).val();

    parent_container_entry.find(".add-option-button").hide();	


    if (value == "YN") {

      if (!initEditing){
        // Clicks the add_option button twice
        parent_container_entry.find(".add-option-button").click();
        parent_container_entry.find(".add-option-button").click();	
      }
      var option_texts = parent_container_entry.find(".option-field .option-text");
      var option_values = parent_container_entry.find(".option-field .option-value");
      // Pre-fills out information, sets class to disabled
      $(option_texts[option_texts.length - 2]).addClass("disabled yes-no").val("Yes");
      $(option_values[option_values.length - 2]).addClass("yes-no").val("yes");
      option_texts.last().addClass("disabled yes-no").val("No");
      option_values.last().addClass("yes-no").val("no");

      // Removes "remove option" button
      parent_container_entry.find(".help-inline a.remove-option").hide();
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
      var followup_option_texts = parent_container_entry.find(".followup-option-field .followup-option-text");
      var followup_option_values = parent_container_entry.find(".followup-option-field .followup-option-value");
      // Pre-fills out information, sets class to disabled
      $(followup_option_texts[followup_option_texts.length - 2]).addClass("disabled yes-no").val("Yes");
      $(followup_option_values[followup_option_values.length - 2]).addClass("yes-no").val("yes");
      followup_option_texts.last().addClass("disabled yes-no").val("No");
      followup_option_values.last().addClass("yes-no").val("no");

      // Removes "remove option" button
      parent_container_entry.find(".followup-option-field a.remove-follow-up-option").hide();
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

  /********** SORTABLE ***************/

  function initSortable(){
    $('.item-container').sortable({
      items:".question-entry",
      update: function(event, ui){
        refreshSequence();
      }
    });
  }

  function refreshSequence(){
    $('.question-entry:visible .sequence').each(function(i,el){
      $(el).val(i);
      //console.log($(el).val());
    });
  }


  // fired on every insertion or removal. TODO: don't set this up until the UI has loaded?
  $(document).on('insertion-callback after-removal-callback', function(){
    refreshSequence();
  });




  /*************  initialization stuff ******************/
  // sortable
  initSortable();

  // question counters
  refreshQuestionCounters();
  $('.confirmation').charCounter();

  // form editing stuff
  if (typeof initEditing === 'undefined') {
    initEditing = false; // ewww global
  }

  if (initEditing === false && $('.question-entry').length === 0) { // make sure we're not editing or failing validation with saved stuff
    //console.log("not editing");
    $('#add_qn_button').click();
  } else {
    //console.log('editing');
    $('.followup-field').trigger('insertion-callback');
    $('.option-text').trigger('insertion-callback');
    $('select.question-type').trigger('change');
    $('select.followup-type').trigger('change');
    initEditing = false;
  }
});
