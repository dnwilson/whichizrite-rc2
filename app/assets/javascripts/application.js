// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(function(){
	$('#datepicker').datepicker({
		format: 'mm/dd/yyyy'
	});
});


// $(function() {
// 	if(!$.support.placeholder) { 
// 		var active = document.activeElement;
// 		$('input[type="text"], textarea').focus(function () {
// 			if ($(this).attr('placeholder') != '' && $(this).val() == $(this).attr('placeholder')) {
// 				$(this).val('').removeClass('hasPlaceholder');
// 			}
// 		}).blur(function () {
// 			if ($(this).attr('placeholder') != '' && ($(this).val() == '' || $(this).val() == $(this).attr('placeholder'))) {
// 				$(this).val($(this).attr('placeholder')).addClass('hasPlaceholder');
// 			}
// 		});
// 		$('input[type="text"], textarea').blur();
// 		$(active).focus();
// 		$('form').submit(function () {
// 			$(this).find('.hasPlaceholder').each(function() { $(this).val(''); });
// 		});
// 	}
// });