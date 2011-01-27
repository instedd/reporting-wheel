module WheelHelper
  def button_to_add_label(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object.label = "__LABEL__"
    new_object.index = "__INDEX__"
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    button_to_function(name, h("add_label(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def link_to_add_value(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object.value = "__VALUE__"
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function('<img class="plus" src="/images/b_plus.png"/>', h("add_value(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :title => name)
  end
  
  def link_to_remove_value(f)
    f.hidden_field(:_destroy, :class => "destroy_value") + link_to_function(image_tag("b_cross.gif", :title => "Delete value"), "remove_value(this)")
  end
  
  def link_to_remove_label(f)
    f.hidden_field(:_destroy, :class => "destroy_label") + link_to_function(image_tag("b_cross_big.gif", :title => "Delete label"), "remove_label(this)")
  end
  
  def print_config_field(f, print_config, key)
    type = print_config.type(key)
    self.send("print_config_field_#{type.to_s}", f, print_config, key)
  end
  
  private
  
  def print_config_field_string(f, print_config, key)
    id = "pc_#{f.id}_#{key}"
    res = print_config.desc(key) + "<br/>"
    res << f.text_field(key, :value => print_config[key], :id => id, :class => 'medsize') + " " 
    res << link_to_function(image_tag("b_cross_big.gif"), "$('##{id}').val('#{print_config.default(key)}')", :title => "Reset to default")
    res
  end
  
  def print_config_field_numeric(f, print_config, key)
    print_config_field_string(f, print_config, key)
  end
  
  def print_config_field_boolean(f, print_config, key)
    res = print_config.desc(key) + " "
    res << f.check_box(key, {:checked => print_config[key]}, "true", "false")
    res
  end
  
end
