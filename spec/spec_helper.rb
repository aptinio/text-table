$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'text-table'
require 'rspec'

def deindent(table)
  table.gsub(/^\s*/, '')
end
