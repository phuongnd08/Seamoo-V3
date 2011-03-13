class Styling < Settingslogic
  source File.join(Rails.root, "config", "styling.yml")
  namespace Rails.env
end
