module Utils
  class RndGenerator
    class << self
      def rnd(exclusive_bound = nil)
        unless exclusive_bound.present?
          rand
        else
          rand(exclusive_bound)
        end
      end

      def next(exclusive_bound, used = {})
        value = nil
        begin
          value = rnd(exclusive_bound)
        end while used[value]
        value
      end

      def rnd_subset(arr, size)
        result = []
        arr = arr.dup
        size.downto(1){ result << arr.delete_at(rnd(arr.size)) }
        result
      end

      def shuffle(arr)
        rnd_subset(arr, arr.size)
      end
    end
  end
end
