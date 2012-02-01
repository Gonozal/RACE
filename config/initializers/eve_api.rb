require "rubygems"
require "active_support"
require "nokogiri"
require "net/https"
require "uri"
require "time"

$LOAD_PATH.unshift(File.dirname(__FILE__))

module EVEAPI
	
end

require "eve_api/api"
require "eve_api/exception"
require "eve_api/cache"
