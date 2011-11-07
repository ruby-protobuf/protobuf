#!/usr/bin/env ruby

require 'addressbook.pb'

def list_people(address_book)
  address_book.person.each do |person|
    puts "Person ID: #{person.id}"
    puts "  Name: #{person.name}"
    puts "  E-mail: #{person.email}" unless person.email.empty?
    person.phone.each do |phone_number|
      print(case phone_number.type
            when Tutorial::Person::PhoneType::MOBILE
              '  Mobile phone #: '
            when Tutorial::Person::PhoneType::HOME
              '  Home phone #: '
            when Tutorial::Person::PhoneType::WORK
              '  Work phone #: '
            end)
      puts phone_number.number
    end
  end
end

unless ARGV.size == 1
  puts "Usage: #{$0} ADDRESS_BOOK_FILE"
  exit
end

address_book = Tutorial::AddressBook.new
address_book.parse_from_file ARGV[0]

list_people address_book
