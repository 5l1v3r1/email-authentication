require 'rubygems'
require 'dnsruby'
include Dnsruby

# Use the system configured nameservers to run a query

module EmailAuthentication
  class Base
    attr_accessor :address, :mx, :message, :domain
  def debug
    true
  end
  def self.check(address)
    tmp=self.new
    return tmp.check(address)
  end
  def set_address(address)
    raise "address nil" if address==nil
    raise "address blank" if address==""
    self.address=address.to_s
    @flag=true
  end
  # this needs work.  Anyone who can improve the regex i would be happy to put in their changes
  # see alsothe validate_email_format gem for rails
  def check_format
    @@email_regex = /^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Z‌​a-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/i
    res=(@address =~ @@email_regex)
    #puts " res is #{res}"
    if res
      [true,"format ok"]
    else
      [false,"format failed"]
    end
  end
  # cache the dns resolver
  def resolver
    @resolver = Dnsruby::Resolver.new if @resolver==nil
    @resolver
  end
  # check the mx domain
  def check_mx
    domain=self.address.split('@')
    @domain = domain[1]
    #puts "domain is #{domain}"
    flag=false
    if @domain!=nil
          begin
           ret = self.resolver.query(@domain, Types.MX)
            if ret.answer!=nil and ret.rcode=='NOERROR'
              @mx=ret.answer.first.exchange.to_s if ret.answer!=nil
              msg= "mx record #{self.mx}"
              puts msg
              flag=true
            end
           rescue Dnsruby::NXDomain 
             msg="non existing domain #{@domain}"
             puts msg
           end
        
    else
      msg="nil domain"
    end
    # puts "ret is #{ret.inspect}"
    [flag,msg]
  end
  # need to think about this and check the domain via telnet
  #S: 220 smtp.example.com ESMTP Postfix
  #C: HELO relay.example.org
  #S: 250 Hello relay.example.org, I am glad to meet you
  #C: MAIL FROM:<bob@example.org>
  #S: 250 Ok
  #C: RCPT TO:<alice@example.com>
  #S: 250 Ok
  
  def check_smtp
     # smtp = Net::Telnet::new("Host" => 'google.com', 'Port' => 25, "Telnetmode" => false)
     # smtp.cmd("user " + "your_username_here") { |c| print c }
     
     [true,"smtp ok"]
   end
   # run all the checks
  def check(address)
    self.set_address(address)
    @message=[]
    puts "checking #{@address}"
    ['format','mx','smtp'].each { |cmd| 
        cmdstring="check_#{cmd}"
        res,msg= self.send(cmdstring)
         @flag=@flag && res
         @message << msg }
    [@flag,@message.join(',').to_s]
  end
 
 

   end    # Class
end    #Module
