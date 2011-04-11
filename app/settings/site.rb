class Site < Settingslogic
  source File.join(Rails.root, "config", "site.yml")
  namespace Rails.env
end
