module Transit
  class Step

    def initialize params
      @instructions = params['html_instructions'].encode('ASCII', encode_options)
      @mode = params['travel_mode']
      @sub_steps = parse_sub_steps params['steps']
    end

    def instructions
      @instructions
    end

    def mode
      @mode
    end

    def sub_steps
      @sub_steps
    end

    def get_directions params
      if @mode == 'walking'
        directions = []
        directions << @instructions
        directions
      elsif @mode == 'transit'
        directions = []
        directions << "Bus number: #{params['transit_details']['line']['short_name']}"
        directions << "Depart from: #{params['transit_details']['departure_stop']['name']}"
        directions << "Arrive at: #{params['transit_details']['arrival_stop']['name']}"
        directions.join('\n')
      else
        raise ArgumentError 'I have no idea how to deal with that transit mode'
      end
    end

    private

    def parse_sub_steps sub_steps
      return nil if sub_steps.nil?

      sub_steps.map { |sub_step| Step.new(sub_step) }
    end

    def get_walking_directions steps
      instructions = steps.map { |step| step['html_instructions'].encode('ASCII', encode_options) }
      instructions.join('\n')
    end

    def encode_options
      {
        invalid: :replace,
        undef: :replace,
        replace: ''
      }
    end
  end
end
