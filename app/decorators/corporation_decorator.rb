class CorporationDecorator < ApplicationDecorator
  def image_path(size)
    "http://image.eveonline.com/Corporation/#{id}_#{size}.png"
  end

  def logo_tag(size)
    "<img src=\"#{image_path(size)}\" alt=\"#{name}\" width=\"#{size}\" height=\"#{size}\" />"
  end
end
