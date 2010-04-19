module EDash
  class ProgressReport
    class Phase
      attr_accessor :name, :value, :width
      def initialize(name, value, width)
        @name = name
        @value = value
        @width = width
      end
      def adjust_width_to(width)
        (width * @width / 100).to_i
      end
    end

    def initialize(json)
      phase_pairs = JSON.parse(json)
      @phases = create_phases_from_pairs(phase_pairs)
    end

    def each(&block)
      @phases.each(&block)
    end

  private
    def create_phases_from_pairs(pairs)
      total_width = calculate_total_width(pairs)
      pairs.collect do |pair|
        Phase.new(pair.first, pair.last.to_i, width_for(pair.last.to_i, total_width))
      end
    end

    def calculate_total_width(pairs)
      pairs.inject(0) do |sum, pair|
        sum += pair.last.to_i
      end
    end

    def width_for(value, total_width)
      value * 100 / total_width.to_f
    end
  end
end
