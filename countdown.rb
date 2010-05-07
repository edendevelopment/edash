module EDash
  class Countdown
    
    class << self
      def store
        Storage.store
      end
      
      def all
        countdowns = nil
        store.transaction do
          countdowns = store['countdowns'] || {}
        end
        countdowns.values
      end

      def save(countdown)
        store.transaction do
          store['countdowns'] ||= {}
          store['countdowns'][countdown.id] = countdown
        end
      end

      def find(id)
        store.transaction do
          countdowns = store['countdowns'] || {}
          countdowns[id]
        end
      end
    end
    
    def self.find_or_create(params)
      countdown = Countdown.find(params['id'])
      return countdown if countdown
      
      countdown = Countdown.new(params)
      save(countdown)
      countdown
    end
    
    def initialize(params)
      @id = "coundownID"
      @description = params['description']
      @timestamp = Time.utc(params['year'], params['month'], params['day'], params['hour'], params['minute'])
    end
    
    attr_reader :id, :description, :timestamp
  end
end
