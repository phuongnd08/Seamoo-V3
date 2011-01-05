namespace :data do
  def do_with_file
    path = ENV["FILE"]
    unless path
      puts "Please specify the file with FILE variable"
    else
      path = File.join(Rails.root, path)
      yield(path)
    end
  end

  def do_with_category
    category_id = ENV["CATEGORY"]
    unless category_id
      puts "Please specify the category id with CATEGORY variable"
    else
      category = Category.find(category_id.to_i)
      unless category
        puts "Subject \##{category_id} does not exist. Please check again"
      else
        yield category
      end
    end
  end

  def do_with_level
    level = ENV["LEVEL"]
    unless level
      puts "Please specify level of data with LEVEL variable"
    else
      yield level
    end
  end

  desc "Import data specified in FILE relative to the Rails.root path"
  task :import => :environment do
    do_with_file do |path|
      puts "Migrate from #{path}"
      do_with_category do |category|
        do_with_level do |level|
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
    do_with_file do |path|
      puts "Unimport [#{path}]"
      unless package = Package.find_by_path(path)
        puts "File [#{path}] is not imported"
      else
        package.unimport!
        puts "Successfully unimport [#{path}]. #{package.entries.count} questions deleted"
      end
    end
  end
end