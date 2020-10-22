$(function() {
	$("select[name=bossname]").on("change", function(e) {
		var name = $("select[name=bossname]").val();
		$("input[name=newbossname]").val(name);
	});
});