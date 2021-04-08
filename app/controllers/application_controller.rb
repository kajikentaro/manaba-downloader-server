class ApplicationController < ActionController::Base
    URL_PREFIX = "https://access.line.me/oauth2/v2.1/authorize?response_type=code&scope=profile%20openid"
    REDIRECT_URI = ERB::Util.url_encode("http://localhost:3000/line_redirect")
    CLIENT_ID = 1655827877
    def login
        state = SecureRandom.urlsafe_base64
        session[:state] = state
        @url = "#{URL_PREFIX}&client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&state=#{state}"
    end
    def line_redirect
        #code=abcd1234&state=0987poi&friendship_status_changed=true
        if params[:state] == session[:state]
           @res =  "params: #{params[:code]}"

        else
            @res = "state exception"
        end
    end

    
  require 'net/https'
  require 'uri'
  def post_message(code)
    data = {
        'grant_type' => 'authorization_code',
        'code' => code,
        'redirect_uri' => 'http://localhost:3000/line_redirect',#URIエンコしたやつを渡すとハマる
        'client_id' => '1655827877',
        'client_secret' => '3efa0bcac5640d168f741da4cc503930'
    }
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/token'),data)
    puts "#{URL_PREFIX}&client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}"
    puts REDIRECT_URI
    puts res.body
    return res
  end
end
