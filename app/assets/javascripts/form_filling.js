$(document).ready(function(){
	
	$('.simple_form').on("change", "select.select", function(event) {

		// Wipes existing options TODO: hide, instead of remove?
		$(this).parents(".question-entry").children(".option_field").remove();
		
		var value = $(this).val();

		var parent_container_entry = $(this).parents(".question-entry");
		console.log(parent_container_entry.find(".add-option-button").hide());	

		if (value == "YN") {	
			// Clicks the add_option button twice
			parent_container_entry.find(".add-option-button").click();
			parent_container_entry.find(".add-option-button").click();	

			// Pre-fills out information, sets class to disabled
			parent_container_entry.find(".option_field input.string").first().addClass("disabled yes-no").val("Yes");
			parent_container_entry.find(".option_field input.string").last().addClass("disabled yes-no").val("No");

			// Removes "remove option" button
			parent_container_entry.find(".help-inline a").remove();
		}
		else if (value == "MULTI") {
			// Show "add option" button
			parent_container_entry.find(".add-option-button").show();	

			// Clicks the add_option button twice 
			parent_container_entry.find(".add-option-button").click();
			parent_container_entry.find(".add-option-button").click();
		}
		else if (value == "OPEN") {
		}
	});
});

function form_options(value) {
	//
	//
}