module EveAssetsHelper
  def nested_assets(assets)
    assets.map do |asset, sub_assets|
      #logger.warn "sub assets: #{sub_assets}"
      render(asset) + content_tag(:div, nested_assets(sub_assets), :class => "indented")
    end.join.html_safe
  end
end
