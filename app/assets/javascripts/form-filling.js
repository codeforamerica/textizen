$(document).ready(function(){
	$('.simple_form').on("change", "select.select", question_type_listener);
});

function question_type_listener(event) {	
	var value = $(this).val();
	$('span.result').text('Value: ' + value); //debugging purposes
	
	if (value == "YN") {
		$('div.options > a.add_fields').next().click(form_options(value));
	}
	else if (value == "MULTI") {
		$('div.options > a.add_fields').next().click(form_options(value));
	}
}


function form_val(value) {
	if (value == "YN")
		$("span.result").text("YN = " + value);
		
	else if (value == "OPTION")
		$("span.result").text("OPTION = " + value);
		$('div.options > a.add_fields').next().click(form_options(value));
	else if (value == "MULTI")
		$("span.result").text("MULTI = " + value);
		$('div.options > a.add_fields').next().click(form_options(value));
}

function form_options(value) {
	//
	//
}
