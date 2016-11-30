require 'octokit'
require 'singleton'
require 'dotenv'
Dotenv.load

module March
  module Github
    class Configuration
      include Singleton

      attr_accessor :username, :password
    end

    def self.configure
      yield(configuration) if block_given?
    end

    def self.configuration
      Configuration.instance
    end

    def self.client
      return @client if @client

      Octokit.api_endpoint = ENV['GITHUB_API'] if ENV['GITHUB_API']
      opts = { :access_token => ENV.fetch('GITHUB_TOKEN') }
      @client = Octokit::Client.new(opts)
      verify = 
        case ENV['VERIFY_SSL'] || 'true'
        when 'false', 'no' then false
        else true
        end

      @client.connection_options[:ssl] = { verify: verify }

      @client
    end
  end
end
