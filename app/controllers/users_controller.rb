class UsersController < ApplicationController

  layout "base"

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
  end

  #--------#
  # create #
  #--------#
  def create
    @user = User.new( params[:user] )

    if @user.save
      flash[:notice] = 'ユーザ登録が完了しました。'
      redirect_to "/memos/list"
    else
      render :action => "new"
    end
  end

  #-------#
  # login #
  #-------#
  def login
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

    redirect_to params[:request_url]
  end

  #--------#
  # logout #
  #--------#
  def logout
    session[:user_id] = nil
    session[:user_name] = nil

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
