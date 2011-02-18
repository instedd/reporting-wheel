$(function(){
	$("#Main_Table").tabs();
	prepare_events();
	$("#submit").click(function(){
		$("#wheel_form").submit();
	});
});

function prepare_events() {
	do_watermarks();
	
	$("#label_name").keydown(add_label_value);
	$(".add_value").keypress(add_label_value);
	
	$( "#labels_list" ).sortable({
		revert: true,
		stop: function(event, ui) {
			var i = 0;
			$("#labels_list li").each(function(index,element){
				$(element).find(".label_index").val(i++);
			});
		}
	});
}

function add_label_value(e) {
	code = (e.keyCode ? e.keyCode : e.which);
	if (code == 13) {
		var input = $(this);
		if (input.val() != "") {
			input.next().click();
		}
		e.preventDefault();
	}
}

function do_watermarks() {
	$("input[placeholder]").placeholder();
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
	var index_regexp = new RegExp("__INDEX__", "g");
	var label_name = $("#label_name").val();
	if (label_name == "") return;
	content = content.replace(id_regexp, new_id).replace(label_name_regexp, label_name).replace(index_regexp, new_id);
	$("#labels_list").append(content);
	prepare_events();
	$("#label_name").val("");
}

function add_value(link, association, content) {
	var new_id = new Date().getTime();
	var id_regexp = new RegExp("new_" + association, "g");
	var value_name_regexp = new RegExp("__VALUE__", "g");
	var value_name = $(link).prev("input[type=text]").val();
	if (value_name == "") return;
	content = content.replace(id_regexp, new_id).replace(value_name_regexp, value_name);
	$(link).closest(".label_box").children(".values").append(content);
	prepare_events();
	$(link).prev("input[type=text]").val("");
}

function should_recalculate_factors(id) {
	if (!validate_form()) {
		return false;
	}
	
	form = $('#wheel_form');
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

function edit_field(object) {
	var parent = $(object).parent();
	var span_label = parent.find("span");
	var input_label = parent.find("input");
	
	span_label.hide();
	input_label.show();
	
	input_label.focus();
	
	var close_edit = function() {
		var value = input_label.val();
		if (value != "") {
			span_label.text(value);

			input_label.hide();
			span_label.show();
		}
	};
	
	input_label.keypress(function(e) {
		code = (e.keyCode ? e.keyCode : e.which);
		if (code == 13) {
			close_edit();
			e.preventDefault();
		}
	});
	input_label.blur(close_edit);
}

function validate_form() {
	var result = true;
	result = result && validate_name();
	result = result && validate_url();
	result = result && validate_labels();
	return result;
}

function validate_labels() {
	var result = true;
	
	// Validate that there is at least one label
	var labels_count = $(".label_box input.destroy_label[value!='1']").size();
	if (labels_count == 0) {
		alert("Please enter at least one label.")
		return false;
	}

	// Validate that each label has a name and at least one value
	$(".label_box input.destroy_label[value!='1']").each(function(index,element){
		var label = $(element).closest(".label_box");
		var label_name = label.find("input.label_name").val();
		if (label_name == "" && result) {
			alert("One of your labels has an empty name. Please enter a name and then submit again.");
			result = false;
		}
		
		var values = label.find(".value input.destroy_value[value!='1']");
		var values_count = values.size();
		if (values_count == 0 && result) {
			alert("The label " + label_name + " hasn't any values. Please enter at least one value for this label.");
			result = false;
		}
		values.each(function(index,element){
			var value_name = $(element).closest(".value").find(".value_name").val();
			if (value_name == "" && result) {
				alert("There is at least one value without name in the label " + label_name + ". Please enter a name for all values and submit again.");
				result = false;
			}
		});
	});

	return result;
}

function validate_name() {
	if ($("#wheel_name").val() == "") {
		alert("Please enter a name for the wheel.");
		return false;
	}
	return true;
}

function validate_url() {
	var url_regexp = new RegExp('((?:http|https)(?::\\/{2}[\\w]+)(?:[\\/|\\.]?)(?:[^\\s"]*))', 'i');
	var url = $("#wheel_url_callback").val();
	if (url != "" && !url.match(url_regexp)) {
		alert("The URL entered in the callback for the wheel is not a valid URL. Please correct the URL and submit again.");
		return false;
	}
	return true;
}