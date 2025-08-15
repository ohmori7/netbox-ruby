module Netbox
	module Extras
		class ConfigTemplates < API
			def render(id)
				ouri = @uri
				@uri.path += "#{id}/render/"
				post({ id: id })
				@uri = ouri
			end
		end
	end
end
