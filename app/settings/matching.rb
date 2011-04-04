class Matching < Settingslogic
  source File.join(Rails.root, "config", "matching.yml")
  namespace Rails.env
  cattr_reader :bots
  cattr_reader :bots_arr

  def self.read_bots
    hash = {}
    File.open(File.join(Rails.root, "config", "bots.txt"), "r").each do |line|
      line.squish!
      unless line.blank?
        if (line =~ /^(\w+)\s(.+)$/)
          hash[$1] = $2
        else
          hash[line] = line
        end
      end
    end
    hash
  end

  @@bots = read_bots
  @@bots_arr = @@bots.each_pair.to_a
end
