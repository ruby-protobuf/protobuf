source 'https://rubygems.org'

gemspec

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
