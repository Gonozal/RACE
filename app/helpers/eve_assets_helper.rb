module EveAssetsHelper
  def nested_assets(assets)
    assets.map do |eve_asset, sub_assets|
      if sub_assets.blank?
        render(eve_asset)
      else
        render(eve_asset) + content_tag(:div, nested_assets(sub_assets), :class => "indented")
      end
    end.join.html_safe
  end
end
