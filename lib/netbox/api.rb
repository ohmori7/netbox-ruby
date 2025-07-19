module Netbox
	class API
		def initialize
			@token = ENV['NETBOX_API_TOKEN']
			name = self.class.name.split('::').drop(1).join('/')
			    .gsub(/([a-z\d])([A-Z])/, '\1-\2')
			    .gsub(/([A-Z]+)([A-Z][a-z]{2,})/, '\1-\2')
			    .downcase
			@uri = URI.parse("#{ENV['NETBOX_URL']}/api/#{name}/")
		end

		def __send(method, params = nil)
			if method == :get
				params = URI.encode_www_form(params) if params
				# XXX: other methods are also okay with this???
				req = Module.const_get("Net::HTTP::#{method.capitalize}").new("#{@uri.path}?#{params}")
			else
				req = Module.const_get("Net::HTTP::#{method.capitalize}").new(@uri)
				req['Content-Type'] = 'application/json'
				if params
					if ! params.is_a?(Array)
						params = [ params ]
					end
					req.body = params.to_json
				end
			end
			req['Authorization'] = "Token #{@token}"
			req['Accept'] = 'application/json'
			response = Net::HTTP.start(@uri.host, @uri.port,
			    :use_ssl => @uri.scheme == 'https',
			    :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |http| http.request(req) }
			r = response.read_body
			if response['Content-Type'] == 'application/json'
				r = JSON.parse(r)
			end
			if response.is_a?(Net::HTTPSuccess)
				# on deletion, a response is not in JSON.
				return r
			else
				raise "ERROR: API failed (#{response.code})\n#{r}"
			end
		end

		def get(params = nil)
			__send(__method__, params)
		end

		def post(params)
			__send(__method__, params)
		end
		alias_method :add, :post

		def put(params)
			__send(__method__, params)
		end

		def patch(params)
			__send(__method__, params)
		end
		alias_method :update, :patch

		def delete(params)
			__send(__method__, params)
		end
	end
end
