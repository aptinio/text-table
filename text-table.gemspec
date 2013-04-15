require File.expand_path('../lib/text-table/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'text-table'
  gem.version = Text::Table::VERSION
  gem.authors = ['Aaron Tinio']
  gem.email = 'aptinio@gmail.com'
  gem.description = 'A feature-rich, easy-to-use plain text table formatter.'
  gem.summary = gem.description
  gem.homepage = 'https://github.com/aptinio/text-table'

  gem.require_paths = ['lib']
  gem.files = `git ls-files`.split($/)
  gem.test_files = `git ls-files -- spec/*`.split($/)
  gem.extra_rdoc_files = %w[LICENSE README.rdoc]
end
