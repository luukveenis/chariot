module Transit
  class Leg

    def initialize params
      @start_location = params['start_address']
      @end_location = params['end_address']
    end

    def start_location
      @start_location
    end

    def end_location
      @end_location
    end
  end
end
