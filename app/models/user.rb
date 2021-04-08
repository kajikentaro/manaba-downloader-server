class User < ApplicationRecord
    #remember_digestがDBに保存されている。

    #記憶トークン。ランダムな文字列
    attr_accessor :remember_token

    #ランダムなトークンを返す
    #staticなメソッド
    def self.new_token
        SecureRandom.urlsafe_base64
    end

    # 与えられた文字列のハッシュ値を返す
    def self.digest(string) #User.digest(string)を同じ意味
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # 永続的セッションで使用するユーザーをデータベースに記憶する
    def remember
        self.remember_token = User.new_token
        #db 更新(updateと一緒)
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # ユーザーのセッションを永続的にする(メインルーチン)
    def remember(user)
        user.remember #Userモデルで定義したrememberメソッド。記憶トークンを作成、ハッシュ化してDBに保存
        cookies.permanent.signed[:user_id] = user.id #ユーザーIDを暗号化してcookieに保存
        cookies.permanent[:remember_token] = user.remember_token #記憶トークンをcookieに保存
    end
end
