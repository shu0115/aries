class UsersController < ApplicationController

  layout "base"
  before_filter :authorize, :except => [ :entry, :confirm, :create, :login, :logout ]

  #-------#
  # index #
  #-------#
  def index
    redirect_to :root and return unless session[:level] == "master"

    @users = User.all
  end

  #-------#
  # entry #
  #-------#
  def entry
    @level_user_count = User.level_users.count
    @commit = params[:commit]
    
    if @commit == "確認"
      @user = User.new( params[:user] )
      @valid_result = @user.valid?
    else
      @user = User.new
      @valid_result = false
    end
  end

  #--------#
  # create #
  #--------#
  def create
    @user = User.new( params[:user] )
    @user.level = "user"
    
    if @user.save
      flash[:notice] = 'ユーザの新規登録が完了しました。'
      redirect_to :controller => "memos", :action => "list"
    else
      flash[:notice] = 'ユーザの新規登録に失敗しました。'
      redirect_to :controller => "users", :action => "new"
    end
  end

  #-------#
  # login #
  #-------#
  def login
    
    params_login = params[:login]

    session[:user_id] = nil
    
    if params_login.blank?
      flash[:notice] = "ログイン情報がありません。"
      redirect_to params[:request_url].to_s
      return
    end
      
    if !params_login[:login_id].blank? and !params_login[:password].blank?
      # ユーザ認証
      user = User.authenticate( params_login[:login_id], params_login[:password] )
     
      unless user.blank?
        print "【 user 】>> " ; p user ;
        session[:user_id] = user.id.to_s  # IDをセッションに格納
        session[:login_id] = user.login_id  # IDをセッションに格納
        session[:level] = user.level
#        flash[:notice] = "ログインに成功しました。"
        redirect_to :controller => "memos", :action => "list"
        return
      else
        flash[:notice] = "無効なユーザ／パスワードの組み合わせです。"
        redirect_to params[:request_url]
        return
      end
    end
  end

  #--------#
  # logout #
  #--------#
  def logout
    session[:user_id] = nil
    session[:login_id] = nil

    redirect_to params[:request_url]
  end

  #------#
  # show #
  #------#
  def show
    @user = User.find( params[:id] )
  end

  #------#
  # edit #
  #------#
  def edit
    @user = User.find( params[:id] )
  end

  #--------#
  # update #
  #--------#
  def update
    @user = User.find( params[:id] )
    
    if params[:user].blank?
      flash[:notice] = 'ユーザ情報がありません。'
      redirect_to :action => "edit", :id => @user.id
      return
    end
    
    # パスワードチェックがtrueで無ければ
    unless @user.password_check?( params[:user][:password] )
      flash[:notice] = '「現在のパスワード」が正しくありません。'
      redirect_to :action => "edit", :id => @user.id
      return
    end

    # ユーザ情報を更新
    if @user.update_attributes( params[:user] )
      session[:user_name] = @user.name
#      flash[:notice] = 'ユーザ情報を更新しました。'
      redirect_to :action => "show", :id => @user.id
      return
    else
      flash[:notice] = 'ユーザ情報の更新に失敗しました。'
      redirect_to :action => "edit", :id => @user.id
      return
    end
  end

  #---------------#
  # edit_password #
  #---------------#
  def edit_password
    @user = User.find( params[:id] )
  end

  #-----------------#
  # update_password #
  #-----------------#
  def update_password
    @user = User.find( params[:id] )
    params_user = params[:user]
    
    if params_user.blank?
      flash[:notice] = 'ユーザ情報がありません。'
      redirect_to :action => "edit_password", :id => @user.id
      return
    end

    # パスワードチェックがtrueで無ければ
    unless @user.password_check?( params_user[:password] )
      flash[:notice] = '「現在のパスワード」が正しくありません。'
      redirect_to :action => "edit_password", :id => @user.id
      return
    end
    
    # 変更するパスワードと再入力パスワードが一致しなければ
    unless params_user[:edit_password] == params_user[:password_confirmation]
      flash[:notice] = '「変更するパスワード」と「変更するパスワード(再入力)」が一致しません。'
      redirect_to :action => "edit_password", :id => @user.id
      return
    end

    # パスワード更新
    params_user[:password] = params_user[:edit_password]

    # ユーザ情報を更新
    if @user.update_attributes( params_user )
      flash[:notice] = 'パスワードを変更しました。'
      redirect_to :action => "show", :id => @user.id
      return
    else
      flash[:notice] = 'パスワードの変更に失敗しました。'
      redirect_to :action => "edit_password", :id => @user.id
      return
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    redirect_to :root and return unless session[:level] == "master"

    @user = User.find_by_id( params[:id] )

    if !(@user.blank?) and session[:level] == "master" and @user.destroy
#      flash[:notice] = "「#{@user.login_id}」の削除が完了しました。"
    else
      flash[:notice] = "「#{@user.login_id}」の削除に失敗しました。"
    end

    redirect_to :controller => "users", :action => "index"
  end

end
