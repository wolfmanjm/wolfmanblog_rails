//= require sha1

$(document).ready(function() {
	$('#login_button').click(function() {
		var n = $('#nonce').val();
		$('#nonce').remove();
		var p = $('#password').val();
		var cp= hex_sha1(p);
		var c = hex_sha1(cp + "-" + n);
		$('#password').val(c);
	});
});
