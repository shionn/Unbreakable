$(function() {
	$(".pure-menu-has-children > a").on("click", function(e){
		$(e.target).closest("li.pure-menu-has-children").toggleClass("pure-menu-active");
	});
});