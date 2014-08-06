require "transit/version"
require "transit/route"
require 'yaml'
require 'pry'
require 'uri'
require 'json'
require 'net/http'

module Transit

  def self.get_routes from, to, time=nil
    time ||= Time.now.to_i
    to = config['transit'][to] if config['transit'][to]
    from = config['transit'][from] if config['transit'][from]
    params = { origin: from, destination: to, departure_time: time }

    uri = URI google_uri
    uri.query = URI.encode_www_form(params)
    resp = Net::HTTP.get_response(uri)
    data = JSON.parse(resp.body)

    routes = []
    data['routes'].each do |route|
      routes << Route.new(route)
    end
  end

  private

  def self.gem_root
    Gem::Specification.find_by_name('transit').gem_dir
  end

  def self.google_uri
    'http://maps.googleapis.com/maps/api/directions/json'
  end

  def self.config
    @config ||= YAML.load_file(File.join(gem_root, 'config/config.yml'))
  end
end
