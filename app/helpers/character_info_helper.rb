module CharacterInfoHelper
  def eve_icon_path(size, icon_name)
    "/images/eve_images/Icons/items/#{size}_#{size}/icon#{icon_name}.png"
  end

  def eve_icon(options = {})
    options[:size] ||= 32
    options[:icon_name] ||= "09_11"
    html = "<img src='#{eve_icon_path(options[:size], options[:icon_name])}'"
    options.delete(:size)
    options.delete(:icon_name)
    options.each {|k, v| html += " #{k.to_s}='#{v}'"}
    html += " />"
  end

  def skill_icon(level)
    if level == 5
      eve_icon(:size => 32, :icon_name => "50_14", :alt => "maxed")
    else
      eve_icon(:size => 32, :icon_name => "50_13", :alt => "skill")
    end
  end
end
