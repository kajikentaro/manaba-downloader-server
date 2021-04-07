class ApplicationController < ActionController::Base
    def login
        state = SecureRandom.urlsafe_base64
        client_id = 1655827877
        redirect_uri = ERB::Util.url_encode("https://google.com");

        @url = "https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=profile%20openid"
        render 'login'
    end
end
