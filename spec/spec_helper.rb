$KCODE='u' if RUBY_VERSION =~ /^1\.8/

require 'rspec/core'
require 'autotest/rspec2'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'text-table'

Dir['./spec/support/**/*.rb'].map {|f| require f}


Spec::Runner.configure do |config|
  
end

class String
  def deindent
    gsub /^[ \t]*/, ''
  end
end
