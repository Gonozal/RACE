class EVEAPI::EveCache < ActiveRecord::Base
  self.table_name = "eveapi_cache"
  
  # loads the requested dataset from the cache.
  # * uri (String) - host uri
  # * params (Hash) - parameter hash {:character_id => 1234567})
  # Example:
  # 
  def self.load(uri, params)
    Time.zone = "Iceland"
    uri_hash = request_to_hash(uri, params)
    return nil if uri_hash.blank?
    cache = EVEAPI::EveCache.find(:first, :conditions => ["request_hash = ? AND cached_until < ?", uri_hash, Time.zone.now])
    if cache.blank?
      nil
    else
      cache.xml
    end
  end
  
  # saves an EVE API query to the cache database
  # Params:
  # * uri (String) - the uri to the api server
  # * params (Hash) - a hash for the parameters to be transfered to the server
  # * xml (String) - The body of the API query / the website to be stored
  # 
  # returns true if save was successful, false otherwise
  def self.save(uri, params, xml)
    Time.zone = "Iceland"
    uri_hash = request_to_hash(uri, params)
    noko = Nokogiri::XML(xml)
    return false if hash.blank? or xml.blank? or noko.blank?
    cached_until = noko.at_xpath("/eveapi/cachedUntil").content
    return false if cached_until.blank?
     
    EVEAPI::EveCache.delete_all( ["request_hash = ?", uri_hash] )
    cache = EVEAPI::EveCache.new
    cache.request_hash = uri_hash
    cache.xml = xml
    cache.cached_until = Time.zone.parse cached_until
    cache.save
  end
  
  # deletes all outdated cache entries
  # should probably only be used at most once per day
  # 
  # Optional:
  # * time - the time after which the records should be deleted regardless of their cached_until value
  # 
  # Example:
  # * Cache.clean(3.days) -  deletes all records whose cached_until value is expired or which
  # were created more than 3 days ago
  def self.clean(time = 5.days)
    Time.zone = "Iceland"
    time = Time.zone.now - time
    self.delete_all( ["cached_until < ? OR created_at < ?", Time.zone.now, time] )
  end
  
  private
  def self.request_to_hash(uri, params)
    raise EVEAPI::Exception::CacheError.new "URI must not be blank" if uri.blank?
    uri = uri.to_s + params.to_hash.hash.to_s
    uri.hash.to_s
  end
end