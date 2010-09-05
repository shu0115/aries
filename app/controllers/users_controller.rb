class UsersController < ApplicationController

  layout "base"
  before_filter :authorize, :except => [ :entry, :confirm, :create, :login, :logout ]

  #-------#
  # entry #
  #-------#
  def entry
    @user = User.new
  end

  #---------#
  # confirm #
  #---------#
  def confirm
    @user = User.new( params[:user] )
    print "【 @user 】>> " ; p @user ;
    valid_result = @user.valid?
    print "【 valid_result 】>> " ; p valid_result ;
  end

  #--------#
  # create #
  #--------#
  def create
    @user = User.new( params[:user] )
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

=begin
      @login = Hash.new
    @login = params[:login]
    print "【 @login 】>> " ; p @login ;
    
    session[:user_id], session[:user_name] = User.login( @login )
    print "【 session[:user_id] 】>> " ; p session[:user_id] ;

    unless session[:user_id].blank?
      #flash[:notice] = 'ログインが完了しました。'
    else
      flash[:notice] = 'ログインに失敗しました。'
    end
=end    

    print "【 params 】>> " ; p params ;
    print "【 params[:login] 】>> " ; p params[:login] ;
    
    login = params[:login]

    print "【 login 】>> " ; p login ;

    session[:user_id] = nil
    
    if login.blank?
      flash[:notice] = "ログイン情報がありません。"
      redirect_to params[:request_url].to_s
      return
    end
      
    if !login[:login_id].blank? and !login[:password].blank?
      # ユーザ認証
      user = User.authenticate( login[:login_id], login[:password] )
      print "【 user 】>> " ; p user ;
     
      unless user.blank?
        session[:user_id] = user.id.to_s  # IDをセッションに格納
        session[:login_id] = user.login_id  # IDをセッションに格納
        flash[:notice] = "ログインに成功しました。"
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

    if @user.update_attributes( params[:user] )
      session[:user_name] = @user.name
      flash[:notice] = 'ユーザ情報を更新しました。'
      redirect_to "/users/show/#{@user.id}"
    else
      render :action => "edit"
    end
  end







  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
