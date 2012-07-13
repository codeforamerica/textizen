$(document).ready(function(){

  // Javascript that fills out value tag when label is filled out

  // TODO THIS BREAKS!
  $(document).on("click", "a.add-followup-dummy", function(event){
    console.log("HellO!");
    $(this).parents(".option-field").find(".add-followup-button").click();
    $(this).parents(".question-entry").addClass("has-follow-up");
    event.preventDefault();
  });

  $(".item-container").on("click", ".remove-follow-up", function (event){
    console.log("remove follow-up");
    $(this).parents(".question-entry").removeClass("has-follow-up");
  });


  /* Autofills the options form when a question type is selected */
  $(".simple_form").on("change", "select.question-type", function(event) {

    // Wipes existing options TODO: hide, instead of remove?
    $(this).parents(".nested-fields").children(".option-field").remove();
    $(this).parents(".question-entry").removeClass("has-follow-up");

    var value = $(this).val();

    var parent_container_entry = $(this).parents(".question-entry");
    parent_container_entry.find(".add-option-button").hide();	


    if (value == "YN") {	
      // Clicks the add_option button twice
      parent_container_entry.find(".add-option-button").click();
      parent_container_entry.find(".add-option-button").click();	

      // Pre-fills out information, sets class to disabled
      parent_container_entry.find(".option-field input.string").first().addClass("disabled yes-no").val("Yes");
      parent_container_entry.find(".option-field input.string").last().addClass("disabled yes-no").val("No");

      // Removes "remove option" button
      parent_container_entry.find(".help-inline a.remove_fields").remove();
    }
    else if (value == "MULTI") {
      // Show "add option" button
      parent_container_entry.find(".add-option-button").show();

      // Find specific input to manipulate
      var input_container_entry = $(this).parents(".option-field");
      console.log("#1: ");
      console.log($(this));
      console.log("#2: ");
      console.log($(this).parents(".option-field"));
      // Array store of all multi values
      var multi_vals = ["A", "B", "C", "D", "E", "F", "G"];

      // Clicks the add_option button twice 
      parent_container_entry.find(".add-option-button").click();
      input_container_entry.find(".option-field input.string").before('<div class="input-prepend"><span class="add-on">' + multi_vals[0] +'</span>');
      input_container_entry.find(".option-field input.string").after('</div>');
      parent_container_entry.find(".add-option-button").click();
      input_container_entry.find('input.string.required').before('<div class="input-prepend"><span class="add-on">' + multi_vals[1] +'</span>');
      input_container_entry.find('input.string.required').after('</div>');
    }
    else if (value == "OPEN") {
    }
  });

  // This is the
  $(".simple_form").on("change", "select.followup-type", function(event) {

    // Wipes existing options TODO: hide, instead of remove?
    $(this).parents(".nested-fields").children(".followup-option-field").remove();

    var value = $(this).val();

    var parent_container_entry = $(this).parents(".followup-field");
    parent_container_entry.find(".add-followup-option-button").hide();	

    if (value == "YN") {	
      // Clicks the add_option button twice
      parent_container_entry.find(".add-followup-option-button").click();
      parent_container_entry.find(".add-followup-option-button").click();	

      // Pre-fills out information, sets class to disabled
      parent_container_entry.find(".followup-option-field input.string").first().addClass("disabled yes-no").val("Yes");
      parent_container_entry.find(".followup-option-field input.string").last().addClass("disabled yes-no").val("No");

      // Removes "remove option" button
      parent_container_entry.find(".followup-option-field a.remove_fields").remove();
    }
    else if (value == "MULTI") {
      // Show "add option" button
      parent_container_entry.find(".add-followup-option-button").show();	

      // Clicks the add_option button twice 
      parent_container_entry.find(".add-followup-option-button").click();
      parent_container_entry.find(".add-followup-option-button").click();
    }
    else if (value == "OPEN") {
    }
  });

});
