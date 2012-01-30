module ApplicationHelper
  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end

  def number_format (number, delimiter = ".")
    number.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1' + delimiter +'\2')
  end

  # This should really be in a helper/decorator
  # How to do this for application views?
  def char_image(char_id, size, alt = false)
    # If alt string is provided, add "alt" tag to img 
    unless alt.blank?
      alt = "alt='#{alt}'"
    end
    # 
    path = "/images/api_images/characters/"
    if FileTest.exist?("#{Rails.root}/public#{path}#{char_id}_#{size}.jpg")
      img_url = "<img src='#{path}#{char_id}_#{size}.jpg' #{alt} />"
    else
      img_url = "<img src='#{path}000000000_#{size}.jpg' #{alt} />"
    end
  end
end
