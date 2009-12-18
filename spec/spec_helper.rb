['table'].each do |lib|
  require File.expand_path(File.dirname(__FILE__) + "/../lib/#{lib}")
end

class String
  def deindent
    gsub /^[ \t]*/, ''
  end
end
