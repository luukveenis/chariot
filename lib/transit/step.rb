module Transit
  class Step

    def initialize params
      @instructions = params['html_instructions']
      @mode = params['travel_mode']
      @transit_details = params['transit_details'] if transit?
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

    def walking?
      @mode == 'WALKING'
    end


    def display
      if walking?
        puts "Not yet implemented"
      elsif transit?
        puts ""
        puts "Depart: #{departure_time}"
        puts "Arrive: #{@transit_details['arrival_time']['text']}"
        puts "Route:  #{@transit_details['line']['short_name']} - #{@transit_details['line']['name']}"
        puts "Departure Stop:   #{@transit_details['departure_stop']['name']}"
        puts "Arrival Stop:     #{@transit_details['arrival_stop']['name']}"
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

    # Colorize the time in red if the bus leaves in 10 or less minutes
    def departure_time
      text = @transit_details['arrival_time']['text']
      if @transit_details['departure_time']['value'].to_i - Time.now.to_i <= 600
        text.colorize(:red)
      else
        text
      end
    end
  end
end
