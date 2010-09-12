require 'digest/sha1'

class User < ActiveRecord::Base
                      
  validates_presence_of :login_id, :message => 'が入力されていません。'  # 存在検証
  validates_presence_of :password, :message => 'が入力されていません。'  # 存在検証
  validates_uniqueness_of :login_id, :message => 'は既に登録されています。'  # 一意検証

  attr_accessor :password_confirmation
  attr_accessor :edit_password
  validates_confirmation_of :password, :message => 'が一致しません。'  # 再入力検証

  #----------#
  # validate #
  #----------#
  # データ検証
  def validate
    errors.add_to_base( "パスワードを設定して下さい。" ) if self.hashed_password.blank?
  end

  #----------#
  # password #
  #----------#
  # 読み込み用メソッド
  # 'password'は仮想属性
  def password
    @password
  end

  #-------------------#
  # password=( pass ) #
  #-------------------#
  # 書き込み用メソッド
  def password=( pass )
    @password = pass

    # ソルト生成
    create_new_salt

    # ハッシュパスワード設定
    self.hashed_password = User.encrypted_password( self.password, self.salt )
  end

  #-----------------#
  # password_check? #
  #-----------------#
  # パスワードチェック
  def password_check?( check_password )

      # 暗号化パスワード生成
      expected_password = User.encrypted_password( check_password, self.salt )
      
      # 暗号化パスワードとハッシュパスワードが一致しなければ
      unless expected_password == self.hashed_password
        return false
      else
        return true
      end
  end

  private
  #-----------------#
  # create_new_salt #
  #-----------------#
  # ソルト生成
  def create_new_salt
    # オブジェクトIDと乱数よりソルトを生成
    self.salt = self.object_id.to_s + rand.to_s
  end

  #-------------------------#
  # self.encrypted_password #
  #-------------------------#
  # 暗号化パスワード生成
  def self.encrypted_password( password, salt )
    string_to_hash = password + "wibble" + salt # 'wibble'を付けて推測されにくくする
    Digest::SHA1.hexdigest( string_to_hash )
  end

  #-------------------#
  # self.authenticate #
  #-------------------#
  # ユーザ認証メソッド(ログイン)
  def self.authenticate( login_id, password )
    # ユーザ検索
    current_user = self.find_by_login_id( login_id )

    unless current_user.blank?
      # 暗号化パスワード生成
      expected_password = encrypted_password( password, current_user.salt )

      # 暗号化パスワードとハッシュパスワードが一致しなければ
      if current_user.hashed_password != expected_password
        # ユーザに[ nil ]を設定
        current_user = nil
      end
    end

    # ユーザを返す
    current_user
  end

end
