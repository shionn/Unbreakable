$(function() {
	$("select[name=item]").on("change", function(e) {
		var item = $("select[name=item]").val();
		var opt = $("select[name=item] option[value="+item+"]");
		$("input[name=wishlist]").prop("checked", opt.data("wish"));
		if ("" !== opt.data("attribution")) {
			$("select[name=attribution]").val(opt.data("attribution"));
		}
	});
});