class MemosController < ApplicationController

  before_filter :login_check
  before_filter :params_cleaning

  layout "base"
  
  $mode_hash = { "public" => "公開", "private" => "非公開" }

  #-------------#
  # login_check #
  #-------------#
  def login_check
    if session[:user_id].blank?
      #flash[:notice] = "ページ上部よりメールアドレス、パスワードを入力しログインして下さい。"
      redirect_to :controller => "public", :action => "list"
    end
  end

  #-----------------#
  # params_cleaning #
  #-----------------#
  def params_cleaning
    params[:id] = nil if params[:id].to_s == "all"
    params[:option] = nil if params[:option].to_s == "all"
    params[:one] = nil if params[:one].to_s == "all"
  end

  #------#
  # list #
  #------#
  def list
    # パラメータ
#    @category = params[:id]
    @category = params[:category]
    @sub_category = params[:sub_category]
    
    # [ session[:memo_mode] ]が空白で無ければ、[ session[:memo_mode] ]を格納
    @mode = session[:memo_mode] unless session[:memo_mode].blank?

    # [ params[:option] ]が空白で無ければ、[ params[:option] ]で上書き
    @mode = params[:option] unless params[:option].blank?
    
    # [ params[:option] ]が「reset」だったら、[ nil ]で上書き
    @mode = nil if params[:option].to_s == "reset" or ( params[:option].blank? and session[:memo_mode].to_s == "reset" )
    
    # paramsをsessionに保存
    session[:memo_mode] = params[:option]

    if params[:commit] == "検索"
      @search_word = params[:search_word]
      @search_type = params[:search_type]
  
      # メモ検索
      if @search_type == "note"
        @all_memos = Memo.paginate( :page => params[:page], :conditions => [ "user_id = :user_id AND note LIKE :search_word", { :user_id => session[:user_id], :search_word => "%#{@search_word}%" } ], :order => "category ASC, sub_category ASC, title ASC", :per_page => $per_page )
        @note_checked = true
      else
        @all_memos = Memo.paginate( :page => params[:page], :conditions => [ "user_id = :user_id AND title LIKE :search_word", { :user_id => session[:user_id], :search_word => "%#{@search_word}%" } ], :order => "category ASC, sub_category ASC, title ASC", :per_page => $per_page )
        @title_checked = true
      end
  
      # ユーザカテゴリ取得
#      @categorys = Memo.user_categorys( :user_id => session[:user_id] )
    else
      # 検索条件
      conditions = Hash.new
      conditions[:category] = @category unless @category.blank?
      conditions[:sub_category] = @sub_category unless @sub_category.blank?
      conditions[:mode] = @mode unless @mode.blank?
      conditions[:user_id] = session[:user_id].to_s unless session[:user_id].blank?
  
      # メモ検索
      @all_memos = Memo.paginate( :page => params[:page], :conditions => conditions, :order => 'category ASC, sub_category ASC, mode ASC, title ASC', :per_page => $per_page )
    end

    # カテゴリ取得
    @categorys = Memo.user_categorys( :user_id => session[:user_id] )

    # サブカテゴリ取得
    @sub_categorys = Memo.user_sub_categorys( :user_id => session[:user_id], :category => @category )

    @title_checked = true
  end
  
  #--------#
  # search #
  #--------#
=begin
  def search
    print "【 params 】>> " ; p params ;
    @search_word = params[:search_word]
    @search_type = params[:search_type]

    # メモ検索
    if @search_type == "note"
      @all_memos = Memo.all( :conditions => [ "note LIKE :search_word", { :search_word => "%#{@search_word}%" } ], :order => "category ASC, title ASC" )
      @note_checked = true
    else
      @all_memos = Memo.all( :conditions => [ "title LIKE :search_word", { :search_word => "%#{@search_word}%" } ], :order => "category ASC, title ASC" )
      @title_checked = true
    end

    # ユーザカテゴリ取得
    @categorys = Memo.user_categorys( :user_id => session[:user_id] )
  end
=end
 
  #---------------#
  # memo_category #
  #---------------#
  def memo_category
    @category = params[:category]
    render :layout => false
  end

  #-------------------#
  # memo_sub_category #
  #-------------------#
  def memo_sub_category
    @sub_category = params[:sub_category]
    render :layout => false
  end

  #------#
  # show #
  #------#
  def show
    @category = params[:category]
    @sub_category = params[:sub_category]
    @memo = Memo.find_by_id_and_user_id( params[:id], session[:user_id] )
  end

  #-----#
  # new #
  #-----#
  def new
    @category = params[:category]
    @sub_category = params[:sub_category]
    
    @memo = Memo.new
    @memo.mode = "private"
    
    @categorys = Memo.user_categorys( :user_id => session[:user_id] )
    @sub_categorys = Memo.user_sub_categorys( :user_id => session[:user_id], :category => @category )
  end

  #------#
  # edit #
  #------#
  def edit
    @category = params[:category]
    @sub_category = params[:sub_category]
    
    @memo = Memo.find_by_id_and_user_id( params[:id], session[:user_id] )
    @categorys = Memo.user_categorys( :user_id => session[:user_id] )
    @sub_categorys = Memo.user_sub_categorys( :user_id => session[:user_id], :category => @category )
  end

  #--------#
  # create #
  #--------#
  def create
    
    @memo = Memo.new( params[:memo] )
    @category = @memo.category
    @sub_category = params[:sub_category]
    @memo.user_id = session[:user_id]

    if @memo.save
      flash[:notice] = "「#{@memo.title}」の新規作成が完了しました。"
      redirect_to :action =>  "show", :id => @memo.id, :category => @category, :sub_category => @sub_category, :one => @mode
      return
    else
      flash[:notice] = "「#{@memo.title}」の新規作成に失敗しました。"
      redirect_to :action =>  "new", :id => @memo.id, :category => @category, :sub_category => @sub_category, :one => @mode
      return
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @memo = Memo.find( params[:id] )
    @category = params[:category]
    @sub_category = params[:sub_category]
    @memo.user_id = session[:user_id]

    update_params = params[:memo]
    update_params[:category] = "None" if update_params[:category].blank?

    if @memo.update_attributes( update_params )
      flash[:notice] = "「#{@memo.title}」の更新が完了しました。"
      redirect_to :action =>  "show", :id => @memo.id, :category => @category, :sub_category => @sub_category, :one => @mode
      return
    else
      flash[:notice] = "「#{@memo.title}」の更新に失敗しました。"
      redirect_to :action =>  "edit", :id => @memo.id, :category => @category, :sub_category => @sub_category, :one => @mode
      return
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @memo = Memo.find_by_id_and_user_id( params[:id], session[:user_id] )
    @category = params[:category]
    @sub_category = params[:sub_category]

    if !@memo.blank? and @memo.destroy
      flash[:notice] = "「#{@memo.title}」の削除が完了しました。"
    else
      flash[:notice] = "「#{@memo.title}」の削除に失敗しました。"
    end

    redirect_to :action =>  "list", :category => @category, :sub_category => @sub_category, :option => @mode
  end
end
