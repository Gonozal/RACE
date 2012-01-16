class SearchController < ApplicationController
  
  def autocomplete
    if params[:searchstring].size() >= 3
      characters = search_for_characters(params[:searchstring])
      corporations = search_for_corporations(params[:searchstring])
      links = search_for_links(params[:searchstring])
      
      @response = characters.merge(corporations).merge(links)
      
      render 'autocomplete'
    else
      render nil
    end
  end
  
  private
  def search_for_characters(str)
    characters = current_account.characters.select([:name, :id]).where("name LIKE :input", {:input => "%#{str}%"}).all
    characters = {
      :characters => characters.map do |c|
        { :name         => c.name,
          :path         => "characters/skills/#{c.id}",
          :description  => nil }
        end
    }
    (characters[:characters].empty?) ? {} : characters
  end
  
  def search_for_corporations(str)
    corporations = Corporation.select([:name, :id]).where("name LIKE :input", {:input => "%#{str}%"}).limit(5).all
    corporations = {
      :corporations => corporations.map do |c|
        { :name         => c.name,
          :path         => "corporations/#{c.id}",
          :description  => nil }
      end
    }
    (corporations[:corporations].empty?) ? {} : corporations
  end
  
  def search_for_links(str)
    logger.warn user_nav
    links = user_nav.select(str).slice 0..4
    links = {
      :links => links.map do |l|
        { :name         => l.name,
          :path         => l.path,
          :description  => l.path }
      end
    }
    (links[:links].empty?) ? {} : links
  end
end
