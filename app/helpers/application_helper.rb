module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def app_version
    begin
      @@app_version = File.read('REVISION').strip[0...10] unless defined? @@app_version
    rescue Errno::ENOENT
      @@app_version = 'Development'
    end
    @@app_version
  end

  def decode_url
    url = url_for :only_path => false, :controller => 'decode', :action => 'wheel'
    url.gsub(/\?.*/,"")
  end
end
