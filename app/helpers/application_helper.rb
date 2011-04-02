module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "removeFields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, raw("addFields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def site_name
    render('misc/site_name')
  end

  def in_competition_system?
    ["categories", "leagues", "matches"].include?(params[:controller]) || in_home_page?
  end

  def in_home_page?
    params[:controller] == "home" && params[:action] == "index"
  end

  def avatar(user, size)
    image_tag user.gravatar_url(:size => size), :size => "#{size}x#{size}"
  end

  include WillPaginate::ViewHelpers::ActionView
 
  def will_paginate_with_i18n(collection, options = {}) 
    will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next))) 
  end

  alias_method_chain :will_paginate, :i18n
end
