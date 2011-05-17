namespace :data do
  def do_with(env_var, msg = nil)
    unless ENV[env_var]
      puts (msg || "Please specify #{env_var}")
    else
      yield ENV[env_var]
    end
  end

  def new_tmp_path
    now = Time.now
    File.join(Rails.root, "tmp", "#{now.to_i}-#{Utils::RndGenerator.rnd(1000)}.tmp")
  end

  def do_with_category
    do_with "CATEGORY", "Please specify the category id with CATEGORY variable" do |category_id|
      category = Category.find(category_id.to_i)
      unless category
        puts "Subject \##{category_id} does not exist. Please check again"
      else
        yield category
      end
    end
  end

  desc "Import data specified in FILE relative to the Rails.root path"
  task :import => :environment do
    do_with "FILE" do |path|
      puts "Migrate from #{path}"
      do_with_category do |category|
        do_with "LEVEL" do |level|
          unless File.exists?(path)
            puts "File [#{path}] does not exist"
          else
            if package = Package.find_by_path(path)
              puts "Package imported, please unimport before reimport"
            else
              package = Package.create(:path => path, :entries => [], :category => category, :level => level)
              package.import
              puts "Successfully process [#{path}]. #{package.entries.count} questions created"
            end
          end
        end
      end
    end
  end

  desc "Unimport data specified in FILE relative to the Rails.root path"
  task :unimport => :environment do
    do_with "FILE" do |path|
      puts "Unimport [#{path}]"
      unless package = Package.find_by_path(path)
        puts "File [#{path}] is not imported"
      else
        package.unimport!
        puts "Successfully unimport [#{path}]. #{package.entries.count} questions deleted"
      end
    end
  end

  desc "Transfer all images into S3"
  task :s3ize => :environment do
    require 'aws/s3'
    require 'RMagick' unless defined?(Magick)
    do_with "IN" do |in_path|
      do_with "OUT" do |out_path|
        open(out_path, "w") do |out_file|
          open(in_path).each do |line|
            line = line.gsub(/(https?:\/\/[^\s\|\:]+)/) do |link|
              tmp_path= new_tmp_path
              rio(link) > rio(tmp_path)
              img = Magick::Image::read(tmp_path).first
              resized = img.resize_to_fit(200, 200)
              resized.write(tmp_path)
              now = Time.now
              s3_path = %{images/#{now.strftime("%Y/%m/%d")}/#{now.to_i}-#{Utils::RndGenerator.rnd(1000)}.jpg}
              AWS::S3::S3Object.store(s3_path, open(tmp_path), :access => :public_read)
              AWS::S3::S3Object.url_for(s3_path, :authenticated => false)
            end

            out_file.puts line
          end
        end
      end
    end
  end
end
