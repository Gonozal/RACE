module EVEAPI::Exception
	class APIError < StandardError
		def initialize(msg, code=nil)
			if code.nil?
				super(msg)
			else
				raise raise_api_exception(code, msg)
			end
		end
		
		private
  	def raise_api_exception(code, msg)
  		dynamic_name = "APIError#{code}"

  		if Object.const_defined? dynamic_name
  			Object.const_get(dynamic_name).new(msg + " (Error: #{code})")
  		else
  			Object.const_set(dynamic_name, Class.new(EVEAPI::Exception::APIError))
  			eval("#{dynamic_name}").new(msg + " (Error: #{code})")
  		end
  	end
	end
	
	class HTTPError < StandardError
	end
	
	class NetworkError < StandardError
	end
	
	class CacheError < StandardError
  end
end