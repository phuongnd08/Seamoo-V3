require 'spec_helper'
require 'rake'
require 'RMagick' unless defined?(Magick)

describe "Data tasks" do
  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/data"
    Rake::Task.define_task(:environment)
  end
  describe "s3ize" do
    it "should s3ize all links" do
      ENV["IN"] = (@in = "spec/files/external_links.data")
      ENV["OUT"] = (@out = "spec/files/s3_links.data")
      Time.stub(:now).and_return(Time.at(10))
      Utils::RndGenerator.should_receive(:rnd).with(1000).and_return(1, 2, 3, 4)
      FileUtils.rm(@out) if File.exists?(@out)
      RIO::Rio.should_receive(:rio).exactly(4).times.and_return { |url|
        if url.starts_with?("http")
          ri = mock(:url => url)
          ri.should_receive(:>){ |file|
            src = ri.url.ends_with?("iphone-1a.jpg") ?
              "#{Rails.root}/spec/files/iphone-1a.jpg" :
              "#{Rails.root}/spec/files/3-29-androids.jpg"
            FileUtils.cp(src, file.path)
          }
          ri
        else
          File.new(url)
        end
      }

      AWS::S3::S3Object.should_receive(:store).exactly(2).times do |s3_path, file, permissions|
        s3_path.should =~ /^images\/1970\/01\/01\/10-[24].jpg$/
          img = Magick::Image::from_blob(file.read).first
        img.columns.should > 0
        img.columns.should <= 200
        img.rows.should > 0
        img.rows.should <= 200
        [img.rows, img.columns].max.should == 200
        permissions[:access].should == :public_read
      end
      @rake["data:s3ize"].invoke
      content = open(@out).each.to_a.join("")
      content.should include("http://s3-ap-southeast-1.amazonaws.com/dautrinet/images/1970/01/01/10-2.jpg")
      content.should include("http://s3-ap-southeast-1.amazonaws.com/dautrinet/images/1970/01/01/10-4.jpg")
      content.should_not include("AWSAccessKeyId")
    end
  end
end
