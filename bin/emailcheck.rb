#!/usr/bin/env ruby
require 'rubygems'
require 'email-authentication'
# needs upgrade to thor
 address = ARGV[0] 
  from=ARGV[1] 
 puts "Address is #{[address]}"
 puts "From address #{from}"
 @f=EmailAuthentication::Base.new
 success,msg=@f.check(address)
 puts "Success: #{address} messages #{msg}" if success
 puts "Failure: #{address} messages: #{msg}" if !success