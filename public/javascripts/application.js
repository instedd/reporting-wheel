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

function draw_wheel_blank_cover() {
  var all_inputs = $("input");
  var count = 0;
  var prefix = "wheel[wheel_rows_attributes]"; 
  var suffix = "[label]";
  for(var i = 0; i < all_inputs.length; i++) {
    var name = all_inputs[i].name; 
    if (name.substr(0, prefix.length) == prefix && name.substr(name.length - suffix.length, suffix.length) == suffix)
      count++;
  }
  window.location = '/wheel/draw_blank_cover?rows_count=' + count;
}

function test_report_code() {
  var code = $("#report_code").val();
  $.get('/decode/test', {'digits':code}, function(data) {
    $("#report_result").html(data);
  });
  return false;
}
