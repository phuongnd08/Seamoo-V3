class LeagueCounter < ActiveRecord::Base
  belongs_to :league

  class << self
    def synchronize(id)
      transaction do
        counter = find(id)
        yield counter
      end
    end
  end
end
