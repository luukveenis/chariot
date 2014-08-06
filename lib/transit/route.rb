require 'transit/leg'

module Transit
  class Route

    def initialize params
      @start_location = params['legs'].first['start_address']
      @end_location = params['legs'].last['end_address']
      @legs = parse_legs params
    end

    def start_location
      @start_location
    end

    def end_location
      @end_location
    end

    def legs
      @legs
    end

    private

    def parse_legs params
      legs = []
      params['legs'].each do |leg|
        legs << Leg.new(leg)
      end
      legs
    end
  end
end
