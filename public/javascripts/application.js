// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$("a#leave_email").click(function(event){
		$("#guest_url").toggle();
		$("#guest_email").toggle();
		event.preventDefault();
	});
});
