function toggle(id) {
  $('#' + id).toggle('fast');
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
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
