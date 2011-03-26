module Utils
  class RndGenerator
    class << self
      def rnd
        rand
      end

      def next(max, used = {})
        value = nil
        begin
          value = (rnd * max).round
        end while used[value]
        value
      end
    end
  end
end
