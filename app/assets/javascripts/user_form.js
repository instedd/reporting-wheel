function initUserForm() {
	$("#submit").click(function(){
		$(this).closest("form").submit();
	});
  $("#Main_Table").tabs();
}
