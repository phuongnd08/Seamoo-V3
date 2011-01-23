class Matching
  @@matching = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'matching.yml'))).result)[Rails.env]
  @@matching.each do |key, value|
     self.instance_eval %{ 
      def #{key}
        @@matching["#{key}"] 
      end
    } 
  end
end
