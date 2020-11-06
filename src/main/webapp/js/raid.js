$(function() {
//	navigator.permissions.query({
//		name : 'clipboard-write'
//	}).then(function(status) {
//		$("a[data-copy]").on("click", function(e) {
//			Clipboard.writeText($(this).data("copy"));
//		})
//	});

	$("a.copy").on("click", function(e) {
		$(this).parent().find("textarea").select();
		document.execCommand("copy");
	})

});