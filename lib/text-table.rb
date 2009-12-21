%w(table row cell enumerable).each do |lib|
  require File.join(File.dirname(__FILE__), 'text-table', lib)
end