class Matching < Settingslogic
  source File.join(Rails.root, "config", "matching.yml")
  namespace Rails.env
  cattr_reader :bots
  cattr_reader :bots_arr

  def self.read_bots
    bots = []
    File.open(File.join(Rails.root, "config", "bots.txt"), "r:utf-8").each do |line|
      line.squish!
      if line =~ /^(\**)(.+)$/
        level = $1.length
        line = $2
        bots[level] ||= {}
        if (line =~ /^(\w+)\s(.+)$/)
          bots[level][$1] = {:display_name => $2, :level => level}
        else
          bots[level][line] = {:display_name => line, :level => level}
        end
      end 
    end
    bots
  end

  @@bots = read_bots
end
