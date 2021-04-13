class ApplicationController < ActionController::Base
    #before_action :session_login, only: [:new]
    require 'net/https'
    require 'uri'
    URL_PREFIX = "https://access.line.me/oauth2/v2.1/authorize?response_type=code&scope=profile%20openid"
    REDIRECT_URI = "http://localhost:3000/line_redirect";
    CLIENT_ID = 1655827877
    def register
        if login?
            #登録処理
        else
            #ログイン画面へリダイレクト
            session[:redirect_uri] = request.url
            redirect_to :action => 'login_page'
        end
    end
    def login_page
        state = SecureRandom.urlsafe_base64
        session[:state] = state
        redirect_uri_encoded = ""
        if session[:redirect_uri]
            redirect_uri_encoded = ERB::Util.url_encode(session[:redirect_uri])
        else
            redirect_uri_encoded = ERB::Util.url_encode(REDIRECT_URI)
        end
        @url = "#{URL_PREFIX}&client_id=#{CLIENT_ID}&redirect_uri=#{redirect_uri_encoded}&state=#{state}"
    end
    def login?
        if session[:user_id] ||(cookies.signed[:user_id] && auto_login)
            return true
        else
            return false
        end
    end
    def auto_login
        user = User.find_by(cookies.signed[:user_id])
        remember_token = cookies[:remember_token]
        if BCrypt::Password.new(remember_digest).is_password?(remember_token)
            session[:user_id] = user.id
            return true
        end
        return false
    end
    def line_redirect
        if params[:state] == session[:state]
           #response = JSON.parse(res.body, symbolize_names: true)
           res = JSON.parse(post_message(params[:code]).body)
           User.create(access_token: res["access_token"], expires_in: res["expires_in"], id_token: res["id_token"])
           @res =  "params: #{params[:code]} \n 保存完了"
        else
            @res = "state exception"
        end
    end
    def post_message(code)
        data = {
            'grant_type' => 'authorization_code',
            'code' => code,
            'redirect_uri' => REDIRECT_URI,
            'client_id' => '1655827877',
            'client_secret' => '3efa0bcac5640d168f741da4cc503930'
        }
        res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/token'),data)
        return res
    end

    def session_login
        if session[:user_id]
            return true
        else
            false
        end
    end
end
