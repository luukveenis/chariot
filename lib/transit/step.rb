module Transit
  class Step

    def initialize params
      @instructions = params['html_instructions'].encode('ASCII', encode_options)
      @mode = params['travel_mode']
      @transit_details = params['transit_details'] if @mode == 'TRANSIT'
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

    def transit?
      @mode == 'TRANSIT'
    end

    def display
      if @mode == 'WALKING'
        puts "Not yet implemented"
      elsif @mode == 'TRANSIT'
        puts "Depart: #{@transit_details['departure_time']['text']}"
        puts "Arrive: #{@transit_details['arrival_time']['text']}"
        puts "Route:  #{@transit_details['line']['short_name']}"
        puts "Stop:   #{@transit_details['departure_stop']['name']}"
      else
        raise 'I have no idea how to deal with that'
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
