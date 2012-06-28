$(document).ready(function(){
	$('.simple_form').on("change", "select.select", function(event) {
		
		var value = $(this).val();
		$('span.result').text('Value: ' + value); //debugging purposes

		// Add and remove YN response form
		if (value == "YN") {
			$('div.nested-fields.options').remove();
			$('div.options > a.add_fields').click();
			yn_form();
		}
		// Add and remove MULTI response form
		else if (value == "MULTI") {
			$('div.nested-fields.options').remove();
			$('div.options > a.add_fields').click();
			multi_form();
		}
		else if (value == "OPEN") {
			$('div.nested-fields.options').remove();
		}
	});
});

function yn_form() {
	$('input.string.required:first').addClass("uneditable-input").val("Yes.");
	$('input.string.required:last').addClass("uneditable-input").val("No.");
}

function multi_form() {
	$('.control-group.string.required').html('<div class="input-prepend"><span class="add-on">A:</span><input class="span2" id="prependedInput" size="" type="text"></div>');
	$('span.add-on:last').text('B');
	/*$('.control-group.string.required').html('<div class="input-prepend"><span class="add-on">B:</span><input class="span2" id="prependedInput" size="" type="text"></div>');
	*/}


function form_options(value) {
	//
	//
}
