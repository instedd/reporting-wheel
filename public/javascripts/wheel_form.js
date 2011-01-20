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
	$(".label_box").draggable({
		helper: "clone"
	});
	$(".drop_box").droppable({
		accept: ".label_box",
		activeClass: 'drop_box_active',
		hoverClass: 'drop_box_hover',
		drop: on_drop
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
	$("#labels").append(content);
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
		span_label.text(input_label.val());
		
		input_label.hide();
		span_label.show();
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

// ---------- Drag & Drop --------------

function drop_box() {
	return '<div class="drop_box">&nbsp;</div>';
}

function add_droppable(selector) {
	selector.droppable({
		accept: ".label_box",
		activeClass: 'drop_box_active',
		hoverClass: 'drop_box_hover',
		drop: on_drop
	});
}

function on_drop(ev, ui) {
	// remove drop_box of the draggable
	ui.draggable.next(".drop_box").remove();
	
	// move the draggable below the droppable	
	$(this).after(ui.draggable);

	// add a drop_box below the draggable
	ui.draggable.after(drop_box());
	add_droppable(ui.draggable.next());
	
	// update indexes
	var new_index = parseInt($(this).prev(".label_box").find(".label_index").val()) + 1;
	ui.draggable.find(".label_index").val(new_index || 0);
	ui.draggable.nextAll(".label_box").each(function(index,element) {
		var index = parseInt($(element).find(".label_index").val());
		$(element).find(".label_index").val(index + 1);
	});
}