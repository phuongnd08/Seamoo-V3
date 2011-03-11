class Matching < Settingslogic
  source File.join(Rails.root, "config", "matching.yml")
  namespace Rails.env
end
