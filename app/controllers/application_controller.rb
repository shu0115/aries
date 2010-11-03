# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # リンク表示テキスト
  $link_name = { :show => "Show", :edit => "Edit", :delete => "Delete", :new => "New", :list => "List" }

  # ページング
  $per_page = 15

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
  
end
