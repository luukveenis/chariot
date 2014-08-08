require 'transit/step'

module Transit
  class Leg

    def initialize params
      @start_location = params['start_address']
      @end_location = params['end_address']
      @steps = parse_steps params['steps']
    end

    def start_location
      @start_location
    end

    def end_location
      @end_location
    end

    def steps
      @steps
    end

    private

    def parse_steps steps
      steps.map { |step| Step.new(step) }
    end
  end
end
