After do |scenario|
  if scenario.source_tag_names.include?("@screenshot")
    feature_name = scenario.feature.name.split("\n").first
    path = File.join(Rails.root, 'features', 'screenshots', feature_name.split(' ').join('_').downcase)
    unless File.exists?(path) && File.directory?(path)
      FileUtils.mkdir_p path
    end
    file_name = File.join(path, scenario.name.split(' ').join('_').downcase + '.jpg')
    File.open(file_name, 'wb') do |f|
      f.write(Base64.decode64(page.driver.browser.screenshot_as(:base64)))
    end
    puts "SCREENSHOT:[#{file_name}] saved"
  end
end 

