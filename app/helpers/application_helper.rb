module ApplicationHelper

  # Return a title on a per-page basis
  # (pour prendre en compte le cas où un titre n'est pas défini pr la page)
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
