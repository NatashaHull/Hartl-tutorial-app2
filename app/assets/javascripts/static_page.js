$(document).ready(function() {
	$('.field').on("keyup", function() {
		var characters = 140 - $("#micropost_content").val().length
		if(characters === 1) {
			$('#character_count').text('1 character left')
		} else {
			$('#character_count').text(characters + ' characters left')
		}
		return false;
	});
})