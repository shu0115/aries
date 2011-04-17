# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # httpsリダイレクト
  before_filter :ssl_redirect

  # リンク表示テキスト
  $link_name = { :show => "Show", :edit => "Edit", :delete => "Delete", :new => "New", :list => "List" }

  # ページング
  $per_page = 15

  # 基本色
  $base_color = "#70c0ff"

  # メモ最大数
  $memo_full = 100

  # ユーザ最大数
  $user_full = 100

  # ログインプロトコル
  if Rails.env.production?
    $login_protocol = "https"
  else
    $login_protocol = "http"
  end

  #---------------#
  # session_clear #
  #---------------#
  def session_clear()
    old_time = Time.now
    old_time = old_time - ( 7 * 24 * 60 * 60 )  # 1week
    Session.destroy_all( [ "updated_at < :old_time", { :old_time => old_time } ] )
  end

  private
  #-----------#
  # authorize #
  #-----------#
  def authorize
    unless User.find_by_id( session[:user_id] )
      flash[:notice] = "ログインして下さい。"
      redirect_to :controller => "users", :action => "login"
    end
  end

  #--------------#
  # ssl_redirect #
  #--------------#
  def ssl_redirect
    # public(http指定)
    if Rails.env.production? and request.env["HTTP_X_FORWARDED_PROTO"].to_s == "https" and params[:controller] == "public"
      request.env["HTTP_X_FORWARDED_PROTO"] = "http"
      redirect_to request.url and return
    end

    # public以外(https指定)
    if Rails.env.production? and request.env["HTTP_X_FORWARDED_PROTO"].to_s != "https" and params[:controller] != "public"
      request.env["HTTP_X_FORWARDED_PROTO"] = "https"
      redirect_to request.url and return
    end
  end
  
end
