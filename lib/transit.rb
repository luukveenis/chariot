require "transit/version"
require "transit/route"
require 'yaml'
require 'pry'
require 'uri'
require 'json'
require 'net/http'
require 'colorize'

module Transit

  def self.get_routes from, to, time=nil, alts
    time = time ? get_utc_time(time) : Time.now.to_i
    to = config['aliases'][to] || to
    from = config['aliases'][from] || from
    params = { origin: from, destination: to, departure_time: time, mode: 'transit', alternatives: alts }


    data = get_google_response(params)
    routes = data['routes'].map { |route| Route.new(route) }
    routes.each_with_index do |route, i|
      puts "========== Route: #{i + 1}".colorize(:blue)
      route.display_bus_only
      puts ""
    end
  end

  def self.add_location name, location
    file = config
    file['transit'][name] = location
    File.open(config_path, "w") do |out|
      YAML.dump(file, out)
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
    YAML.load_file(config_path)
  end

  def self.config_path
    File.join(gem_root, 'config/config.yml')
  end

  def self.get_utc_time time
    now = Time.now
    Time.new(now.year, now.month, now.day, time).to_i
  end

  def self.get_google_response params
    uri = URI google_uri
    uri.query = URI.encode_www_form(params)
    resp = Net::HTTP.get_response(uri)
    JSON.parse(resp.body)
  end
end
