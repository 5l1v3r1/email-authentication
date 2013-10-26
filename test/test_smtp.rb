#uts File.dirname(__FILE__)
require File.dirname(__FILE__) + '/test_helper.rb' 


class EmailSMTPAuthenticationTest <  Minitest::Test

  def setup
    @f=EmailAuthentication::Base.new
    @success='scott.sproule@ficonab.com'
    @from='scott.sproule@estormtech.com'
    @success2='info2@paulaner.com.sg'
  end
  
  def test_google_mx
        @f.set_address(@success,@from)
        success,msg= @f.check(@success,@from)
        assert success,"check did not succeed"
        puts msg
    end
    
    def test_smtp_mx
           success,msg= @f.check(@success2,@from)
           # uncomment this if not on travis as travis seems to block the port
          # assert success,"check did not succeed #{msg}"
           puts msg
    end
 

end