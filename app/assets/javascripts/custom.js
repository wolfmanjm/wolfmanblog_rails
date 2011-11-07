$(document).ready(function() {
	$("a#leave_email").click(function(event){
		$("#guest_url").toggle();
		$("#guest_email").toggle();
		event.preventDefault();
	});
});

