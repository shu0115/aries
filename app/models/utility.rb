# 汎用メソッド用クラス
class Utility

  #----------------------------#
  # self.error_message_replace #
  #----------------------------#
  # エラーメッセージ置換
  def self.error_message_replace( args )
    message = args[:message]
    message = message.gsub( "errors prohibited this user from being saved", "エラー" )
    message = message.gsub( "error prohibited this user from being saved", "エラー" )
    message = message.gsub( "There were problems with the following fields:", "以下の項目にエラーがあります。" )
    message = message.gsub( "Login", "ログインID" )
    message = message.gsub( "Password", "パスワード" )
    return message
  end

  #--------------#
  # self.f_round #
  #--------------#
  # 小数点四捨五入演算
  def self.f_round( args )
    precision = "1"
    1.upto( args[:precision] ){ precision += "0" }
    args[:number] = ( args[:number].to_f * precision.to_i ).round / precision.to_f

    return args[:number]
  end

  #----------------------#
  # self.digit_delimiter #
  #----------------------#
  # 桁区切り
  def self.digit_delimiter( args )
    args[:number].to_s.reverse.gsub(/(\d{#{args[:digit]}})(?=\d)/, ('\1' + args[:delimiter])).reverse
  end

end