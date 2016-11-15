require 'spec_helper'

RSpec.configure do |config|
  config.before do
    @head = %w( a    bb   ccc  dddd )
    @rows = [
            %w( aa   bbb  cccc d    ),
            %w( aaa  bbbb c    dd   ),
    ]
    @foot = %w( aaaa b    cc   ddd  )
  end
end
