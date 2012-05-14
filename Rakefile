require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'


require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "text-table"
  gem.summary = %Q{A feature-rich, easy-to-use plain text table formatter.}
  gem.description = %Q{Allows you to easily create and format plain text tables, useful when working with the terminal or when you want to quickly print formatted tables to a dot-matrix printer.}
  gem.email = "aptinio@yahoo.com"
  gem.homepage = "http://github.com/aptinio/text-table"
  gem.authors = ["Aaron Tinio"]
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'jeweler'
  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec
task :test => :spec # for rubygems-test
