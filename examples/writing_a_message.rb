#!/usr/bin/env ruby

require 'addressbook.pb'

def prompt_for_address(person)
  print 'Enter person ID number: '
  person.id = STDIN.gets.strip.to_i
  print 'Enter name: '
  person.name = STDIN.gets.strip
  print 'Enter email address (blank for none): '
  email = STDIN.gets.strip
  person.email = email unless email.empty?

  loop do
    print 'Enter a phone number (or leave blank to finish): '
    break if (number = STDIN.gets.strip).empty?

    person.phone << Tutorial::Person::PhoneNumber.new
    person.phone.last.number = number

    print 'Is this a mobile, home, or work phone? '
    person.phone.last.type = 
      case type = STDIN.gets.strip
      when 'mobile'
        Tutorial::Person::PhoneType::MOBILE
      when 'home'
        Tutorial::Person::PhoneType::HOME
      when 'work'
        Tutorial::Person::PhoneType::WORK
      else
        puts 'Unknown phone type; leaving as default value.'
        nil
      end
  end
end

unless ARGV.size == 1
  puts "Usage: #{$0} ADDRESS_BOOK_FILE" 
  exit
end

address_book = Tutorial::AddressBook.new
address_book.parse_from_file ARGV[0] if File.exist? ARGV[0]
address_book.person << Tutorial::Person.new
prompt_for_address address_book.person.last
address_book.serialize_to_file ARGV[0]
