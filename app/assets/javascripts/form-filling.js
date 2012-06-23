$('select.select').bind('change', function(){ 
	console.log('Value changed'); 
	if $('select.select').val() == 'YN' {
			console.log('Yes/No Selected'); }
});

/*$(document).ready(function() {  

	
	$('select.select').change(function(
		console.log($('select.select').val());
		){
			if (val == 'YN') 
				console.log($('select.select').val());
			else if (val == 'MULTI') 
				console.log($('select.select').val());
			else  (val == 'OPEN') 
				console.log($('select.select').val());
			
		})
		
	});*/




		/*function yesnoPoll() {
			console.log("Yes/No poll initiated.");
			$("label.control-label").text("A").addClass(".yes-no-active");
			$("label.control-label").text("B").addClass(".yes-no-active");
			$("label.control-label").text("C").addClass(".yes-no-inactive");
	
			if $(click.("input.inactive")) {
				$(".yes-no-inactive").replaceClass(".yes-no-active");
				// Add another 'd'... incrementing option
			}
		}*/