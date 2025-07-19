# frozen_string_literal: true

require_relative "netbox/version"
require_relative "netbox/api"
require_relative "netbox/ipam"
require_relative "netbox/dcim"

module Netbox
	class Error < StandardError; end

	# XXX: platform independent path configuration...
        ENV['GOOGLE_APPLICATION_CREDENTIALS'] ||= File.join(Dir.home, ".config/gcloud/credentials.json")
	ENV['NETBOX_URL'] ||= 'http://localhost:8000'
	ENV['NETBOX_API_TOKEN'] ||= File.read(File.join(Dir.home, ".config/netbox/netbox-api-token.txt")).strip
end
