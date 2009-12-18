$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'table'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

class String
  def deindent
    gsub /^[ \t]*/, ''
  end
end
