Dir["#{Rails.root}/config/*.yml"].each do |filename|
  name = File.basename(filename).chomp(File.extname(filename))
  unless [/database/, /cucumber/].any?{ |pattern| name =~ pattern }
    class_name = "#{name}_setting".classify + "s"
    klass = Class.new(Settingslogic)
    klass.source filename
    klass.namespace Rails.env
    Object.const_set(class_name, klass)
  end
end
