function toggle(id) {
  $('#' + id).toggle('fast');
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
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
