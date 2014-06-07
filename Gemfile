source 'https://rubygems.org'

gem "berkshelf",  "~> 3.0"
gem "rake"
gem "yarjuf"

group :development do
  gem 'guard'
  gem 'growl'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'foodcritic', github: "acrmp/foodcritic"
  gem 'chefspec', "~> 3.0"
end

group :integration do
  gem 'test-kitchen', '~> 1.2'
  gem 'kitchen-docker'
  gem 'kitchen-vagrant'
end
