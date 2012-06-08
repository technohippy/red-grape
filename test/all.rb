require 'test/unit'
Dir["#{File.dirname(__FILE__)}/test_*.rb"].each do |name|
  require name
end
