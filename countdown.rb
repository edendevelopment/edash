module EDash
  class Countdown
    
    def self.find_or_create(params)
      @countdown = Countdown.new(params)
    end

    def self.all
      [@countdown].compact
    end
    
    def initialize(params)
      @id = "coundownID"
      @description = params['description']
      @timestamp = Time.utc(params['year'], params['month'], params['day'], params['hour'], params['minute'])
    end
    
    attr_reader :id, :description, :timestamp
  end
end
