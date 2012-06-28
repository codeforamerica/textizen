$(document).ready(function(){
	$('.simple_form').on("change", "select.select", function(event) {
		
		var value = $(this).val();
		$('span.result').text('Value: ' + value); //debugging purposes

		if (value == "YN") {
			$('div.options > a.add_fields').click();
			yn_form();
		}
		else if (value == "MULTI") {
			$('div.options > a.add_fields').click();
			multi_form();
		}
	});
});

function yn_form() {
	$('input.string.required:first').addClass("uneditable-input").val("Yes.");
	$('input.string.required:last').addClass("uneditable-input").val("No.");
}

function multi_form() {
	$('input.string.required:first').val("A");
}


function form_options(value) {
	//
	//
}
