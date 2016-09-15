module ApplicationHelper

  def nav_link_for_controller(controller, text, path)
    options = params[:controller] == controller ? { class: "active" } : {}
    content_tag(:li, options) do
      link_to text, path
    end
  end

end
