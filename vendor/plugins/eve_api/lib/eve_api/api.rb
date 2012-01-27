# Class used for basic API interaction. This is the class you should instantiate first.
# 
# Example usage:
# 
# @example Initialize (for account related queries)
#     api = EVEAPI::API.new
#     api.api_id = 1234567
#     api.api_key = "A7416C2DAA5D4283AE3EE7BB8F27BDBC96F3A01B14534656842A9783AC135A8A"
#   
# @example Get Accounts for this cahracter:
#   xml = api.account.Characters.get
#   xml = api.account.Characters.get(:version => "1.2")
# 
# @example Alternative Syntax:
#   xml = api.get("account/Characters") 
#   xml = api.get("account/Characters", :version => "1.2")
# 
# Note: The alternativ syntax is generally prefered as it does not involve
# hacking the method_missing method
# 
# More Information about the EVE API is available on
# the {http://wiki.eve-id.net/Main_Page EVE API wiki page}
class EVEAPI::API
  # Can be set in order to avoid having a huge params hash in the get method.
  # Maps directly to the camelCase versions of the EVE API.
  # 
  # @param [String] value The value to set
  # @return [String]
	attr_writer :api_id, :v_code, :character_id, :corporation_id, :alliance_id, :account_key, :from_id, :row_count, :version, :ids,
				:contract_id
	attr_accessor :host, :extension, :image_path_array

	# Initializes the api host adress, extensions for api calls etc.
	# 
	# Defaults are:
	#   host: https://api.eveonline.com
	#   extension: .xml.aspx
	#   image_path: images/api_images/
	#
	# @param [hash] params the parameter hash. Possible parameters:
	# 
	#   :host => [string] the server to which to connect
	# 
	#   :extension => [string] the extension to apply to all queries
	#   (except for a few specific queries like save_image etc.
	# 
	#   :image_path => [string] the path where to out the images to.
	#   Fodlers should be seperated with a forward slash (like in unix style OS)
	#
	# @example Initialize with defaults:
	#   api = EVEAPI::API.new
	# 
	# @example initialize with custom host and extension:
	#   api = EVEAPI::API.new({
	#     :host => "https://eveapi.com",
	#     :extension => ".xml"})
	def initialize(params = {})
    params[:host] ||= "https://api.eveonline.com"
    params[:extension] ||= ".xml.aspx"
    params[:image_path] ||= "images/api_images"
    self.host = params[:host]
    self.extension = params[:extension]
    self.image_path_array = params[:image_path].split(/\/|\\/)
    @query = ""
	end
	
	# Executes a query to the API server. Either used at the and of a hacky
	# mess of method_missing calls like api.account.Characters.get or by specifing
	# an API URI.
	#
	# @param [String, Hash] query the string beeing used as the adress to the specific EVE API site. alternatively the params hash. (see params)
	# @param [Hash] params A hash containing additional key-value pairs to be transmitted to the API server.
	#   examples would be: { :character_id => "123456" , :api_id => "654321"}. Can either be in small camelCase
	#   (EVE API format) or in underscore notation (as in this example)
	# 
	# @raise [EVEAPI::Exception] When something with the request went wrong, some exceptions are raised.
	#   Most noteably: EVEAPI::Exception::APIError when the eve-api responded with an error. These 
	#   errors come with an error code within the name and the description provided by the EVE API.
	# 
	#   API request that result in an EVE API error are cached to prevent spamming the api with invalid
	#   requests.
	# 
	# @return [Nokogiri::XML::Document] a Nokogiri XML Document representing the server response
	# 
	# @example "proper" syntax:
	#   api.get("account/Characters", :version => "1.2")
	# 
	# @example "messy" syntax:
	#   api.account.Characters.get(:version => "1.2")
	def get(query = {}, params = {})
	  if !query.blank? and query.class.to_s == "String"
	    @query = (query =~ /^\//) ? query : "/#{query}"
    else 
      params = query
    end
    # URI consists of the host + query + file extension
    uri = "#{@host}#{@query}#{@extension}"

    # query is not needed anymore and should be reset so that
    # the next query can be made
    @query = ""

    # build hash with essential post parameters
    essentials = {
      :keyID => @api_id,
      :vCode => @v_code,
      :characterID => @character_id,
      :allianceID => @alliance_id,
      :corporationID => @corporation_id,
      :accountKey => @account_key,
      :fromID => @from_id,
      :rowCount => @row_count,
      :version => @version,
      :ids => @ids,
      :contractID => @contract_id
    }.delete_if { |k, v| v.nil? }

    params_new = {}
    # change ruby naming conventions to API naming conventions
    params.each do |key,val|
      key_new = key.to_s if key.class.to_s == "Symbol"
      key_new = key_new.camelcase.gsub(/Id/, 'ID')
      key_new[0] = key_new[0].downcase
      parasms_new[key_new] = params[key]
    end
    params = params_new

    # merge param hash and essentials together
    params.merge! essentials
    request_xml(uri, params)
	end
	
	# Saves a Image (cpororation, character etc) from an api call and saves
	# it to the file System for late usage.
	# 
	# for more Information on the EVE Image API see
	# {http://wiki.eve-id.net/APIv2_Eve_Image_Service the api wiki}
	# or {http://image.eveonline.com/ the official image api documentation}
	# 
	# @param [string] type the type of image you want. Possible options are: 
	#   'character', 'alliance', 'corporation', 'inventory_type' or 'render'.
	# @param [integer] id the Id of the image you want. For a character this would be
	#   the character ID, for a alliance the alliance ID and so on.
	# @param [integer] size The Size the image should have. Possible options are 
	#   (for most queries, check the api reference for more information): 32, 64, 128, 256.
	# 
	# @return [pathname] the path to the saved image
	def save_image(type, id, size=64)
	  # get the required file extension: Character portraits are saved as .jpg
	  # everything else is a PNG image
	  file_extension = (type =~ /^character$/i) ? 'jpg' : 'png'
	  
	  # create (if needed) the folders needed to save the images
	  save_path = Rails.root.join('public')
	  image_folders = image_path_array.clone << type.pluralize
	  image_folders.each do |folder|
	    save_path = save_path.join(folder)
	    # create the folder if it does not already exist
	    Dir.mkdir(save_path) unless File.directory?(save_path)
	  end
	  
	  # create the filename consiting of the id_size.png|jpg
	  filename = "#{id}_#{size}.#{file_extension}"
	  
	  # the adress to connect to
	  uri = "https://image.eveonline.com/#{type.camelcase}/#{filename}"
	  save_path = save_path.join(filename)
	  # get the image
	  res = connect(uri)
	  open(save_path, 'wb') { |file|
      file.write res.body
    }
    
    save_path
	end
	
	# deletes all images of a specified type
	# 
	# Works similiar to save_image except that it deletes all possible sizes
	# of images associated to this particular type and id
	# 
	# @param [string] type the type of image you want. Possible options are: 
	#   'character', 'alliance', 'corporation', 'inventory_type' or 'render'.
	# @param [integer] id the Id of the image you want. For a character this would be
	#   the character ID, for a alliance the alliance ID and so on.
	def delete_image(type, id)
	  sizes = [30,32,48,64,128,200,256,512,1024]
	  # get the required file extension: Character portraits are saved as .jpg
	  # everything else is a PNG image
	  file_extension = (type =~ /^character$/i) ? 'jpg' : 'png'
	  # create (if needed) the folders needed to save the images
	  delete_path = Rails.root.join('public')
	  image_folders = image_path_array.clone << type.pluralize
	  image_folders.each do |folder|
	    delete_path = delete_path.join(folder)
	    # cancel if no directory could be found
	    return unless File.directory?(delete_path)
	  end
	  
	  # initialize empty filename string
	  filename = ""
	  
	  # Iterate over all sizes
	  sizes.each do |size|
	    # create filename
	    filename = "#{id}_#{size}.#{file_extension}"
	    # delete the file if it exists
	    File.delete(delete_path.join(filename)) if File.file?(delete_path.join(filename))
	  end
	end
	
	
	# returns the path to the image specified by the type of the image to load
	# 
	# @param [string] type the type of image you want. Possible options are: 
	#   'character', 'alliance', 'corporation', 'inventory_type' or 'render'.
	# 
	# @return [pathname] the path to the saved image
  # (see #self.image_path)
	def image_path(type)
	  image_folders = image_path_array.clone << type.pluralize
	  Rails.root.join('public', *image_folders)
  end
	
	private
	def request_xml(uri, params)
		# qery cache bevore querying EVE API
		xml = EVEAPI::EveCache.load(uri, params)
		if not xml  # if not cached
			# establish connection to the remote site
			# connect raises exeptions if anything went wrong
			res = connect(uri, params)
			# save result in cache
			xml = res.body
			# raise en exception when the query could not be saved to the cache database
			unless EVEAPI::EveCache.save(uri, params, res.body)
			  raise EVEAPI::Exception::CacheError.new "Could not save the respond to the api call '#{uri}' to the database"
		  end
		end
		xml_or_exception(xml)
	end
	
	def xml_or_exception(xml)
	  xml = Nokogiri::XML(xml)
	  if xml.xpath("/eveapi/error").length > 0
			# API error detected
			error = xml.xpath("/eveapi/error").first
			raise EVEAPI::Exception::APIError.new(error.text, error['code'])
		elsif xml.xpath("/eveapi/result").length < 1
			raise EVEAPI::Exception::APIError.new("Unknown API Error detected. Result element not found.")
		else
		  # alles okay
		  xml
	  end
	end
	
	# handles the connection to the EVE API server specified as host
	# 
	# @param [string] uri the uri to connect to. 
	# @param [hash] params params to be transmitted to the server via GET
	# @param [boolean] ssl weather to use secure connection or not. Note: NO 
	#   SSL verification is required!
	# 
	# @return NET::HTTPResponse the response of the server. for detailed information
	#   see {http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html NET::HTTP}
	def connect(uri, params = nil, ssl = true)
	  source = URI.parse(format_uri(params, uri))
		http = Net::HTTP.new(source.host, source.port)
		# weather SSL (https) should be used or not
		http.use_ssl = ssl
		# Disable ssl (https) certification as it is only used to
		# allow for secure connection. Certification is not needed in this case
		# and may break the conncetion progress
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(source.path + format_uri(params))
		res = http.request(request)
		
		# TODO: custom Exceptions!
		case res
	  when Net::HTTPOK
		when Net::HTTPNotFound
			raise EVEAPI::Exception::HTTPError.new "The requested API (#{url.path}) could not be found."
		else 
			raise "An HTTP Error occured, body: " + res.body
		end
		res
	end
	
			
	def format_uri(params, uri = "")
	  return uri if params.blank?
	  uri = uri.clone
		uri << "?"
		params.each { |k, v| uri << "#{URI.encode k.to_s}=#{URI.encode v.to_s}&" }
		uri.gsub(/\&$/, '') unless gsub.blank?
	end
	
	# saves every unknown command in a query seperated with a slash.
	# 
	# api.account.Characters results in @query = "account/Characters".
	# 
	# This query is then used as the API URI when connecting to the server.
	# Host and extensions get pre/appended of course 
	def method_missing(meth, *args, &blk)
		super if args.length > 0 or not blk.nil?
		@query << "/#{meth.to_s}"
		return self
	end
end