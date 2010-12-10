function toggle(id) {
  $('#' + id).toggle('fast');
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function remove_value(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest("span").hide();
}

function remove_label(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".label_box").hide();
}

function add_label(link, association, content) {
	var new_id = new Date().getTime();
	var id_regexp = new RegExp("new_" + association, "g");
	var label_name_regexp = new RegExp("__LABEL__", "g");
	var label_name = $("#label_name").val();
	content = content.replace(id_regexp, new_id).replace(label_name_regexp, label_name);
	$("#labels").append(content);
	$("#label_name").val("");
	do_watermarks();
}

function add_value(link, association, content) {
	var new_id = new Date().getTime();
	var id_regexp = new RegExp("new_" + association, "g");
	var value_name_regexp = new RegExp("__VALUE__", "g");
	var value_name = $(link).prev("input[type=text]").val();
	content = content.replace(id_regexp, new_id).replace(value_name_regexp, value_name);
	$(link).closest(".label_box").children(".values").append(content);
	$(link).prev("input[type=text]").val("");
	do_watermarks();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}

function test_report_code() {
  var code = $("#report_code").val();
  $.get('/decode/test', {'digits':code}, function(data) {
    $("#report_result").text(data);
  });
  return false;
}

function should_recalculate_factors(id) {
	form = $('#edit_form');
	form_data = form.serialize();
	$.post('/wheel/should_recalculate/' + id, form_data, function(data) {
		response = eval(data);
		if (response) {
			if (confirm("Your new wheel has more rows or more values in one row. This means that the old wheel won't work anymore and you need to print it again and redistribute. Are you sure you want to continue?")) { 
				form.submit();
			}
		} else {
			form.submit();
		}
	});
}
