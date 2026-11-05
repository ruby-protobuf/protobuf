source 'https://rubygems.org'

gemspec

# CI sets RAILS_VERSION (for example "~> 6.1.0") to test each supported Rails.
# railties is also a gemspec development dependency, so only activesupport is
# pinned here and railties follows it.
if (rails_version = ENV['RAILS_VERSION'])
  gem 'activesupport', rails_version
end

group :development do
  # debuggers only work in MRI
  if RUBY_ENGINE.to_sym == :ruby
    gem 'pry'
    gem 'pry-byebug'
    gem 'pry-stack_explorer'

    gem 'ruby-prof'
    gem 'varint'
  elsif RUBY_PLATFORM =~ /java/i
    gem 'fast_blank_java'
    gem 'pry'
  end
end
