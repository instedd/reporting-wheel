module WheelHelper
  def button_to_add_label(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object.label = "__LABEL__"
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
    link_to_function('<img src="/images/b_plus.png"/>', h("add_value(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :title => name)
  end
  
  def link_to_remove_value(f)
    f.hidden_field(:_destroy) + link_to_function(image_tag("b_cross.gif", :title => "Delete value"), "remove_value(this)")
  end
  
  def link_to_remove_label(f)
    f.hidden_field(:_destroy) + link_to_function(image_tag("b_cross_big.gif", :title => "Delete label"), "remove_label(this)")
  end
end
