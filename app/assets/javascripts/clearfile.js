$("#clearfile").onclick(function(event){
	evenet.preventDefault();
	$("#post_p_image").replaceWith("<input type='file' id='post_p_image' name='post[p_image]' data-provide='fileupload' />");
	$('.preview').toggle();
});