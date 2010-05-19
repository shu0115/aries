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
      redirect_to "/public/list"
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
    @category = params[:id]
    
    @mode = session[:memo_mode] unless session[:memo_mode].blank?  # [ session[:memo_mode] ]が空白で無ければ、[ session[:memo_mode] ]を格納
    @mode = params[:option] unless params[:option].blank?          # [ params[:option] ]が空白で無ければ、[ params[:option] ]で上書き
    @mode = nil if params[:option].to_s == "reset" or ( params[:option].blank? and session[:memo_mode].to_s == "reset" )  # [ params[:option] ]が「reset」だったら、[ nil ]で上書き
    session[:memo_mode] = params[:option]                          # paramsをsessionに保存

    conditions = Hash.new
    conditions[:category] = @category unless @category.blank?
    conditions[:mode] = @mode unless @mode.blank?

    @all_memos = Memo.all( :conditions => conditions, :order => "category ASC, mode ASC, title ASC" )
    @categorys = Memo.categorys
    print "【 @categorys 】>> " ; p @categorys ;
  end
  
  #---------------#
  # memo_category #
  #---------------#
  def memo_category
    @category = params[:category]
    render(:layout => false)
  end

  #------#
  # show #
  #------#
  def show
    @category = params[:option]
    @memo = Memo.find( params[:id] )
  end

  #-----#
  # new #
  #-----#
  def new
    @category = params[:id]
    @memo = Memo.new
    @memo.mode = "private"
    @categorys = Memo.categorys
  end

  #------#
  # edit #
  #------#
  def edit
    @category = params[:option]
    @memo = Memo.find( params[:id] )
    @categorys = Memo.categorys
  end

  #--------#
  # create #
  #--------#
  def create
    
    @memo = Memo.new( params[:memo] )
    @category = @memo.category
    @memo.user_id = session[:user_id]

    if @memo.save
      flash[:notice] = "「#{@memo.title}」の新規作成が完了しました。"
      redirect_to "/memos/show/#{@memo.id}/#{@category}/#{@mode}"
    else
      flash[:notice] = "「#{@memo.title}」の新規作成に失敗しました。"
      redirect_to "/memos/new/#{@category}/#{@mode}"
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @memo = Memo.find( params[:id] )
    @category = params[:option]
    @memo.user_id = session[:user_id]

    update_params = params[:memo]
    update_params[:category] = "None" if update_params[:category].blank?

    if @memo.update_attributes( update_params )
      flash[:notice] = "「#{@memo.title}」の更新が完了しました。"
      redirect_to "/memos/show/#{@memo.id}/#{@memo.category}/#{@mode}"
    else
      flash[:notice] = "「#{@memo.title}」の更新に失敗しました。"
      redirect_to "/memos/edit/#{@memo.id}/#{@memo.category}/#{@mode}"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @memo = Memo.find( params[:id] )
    @category = params[:option]

    if @memo.destroy
      flash[:notice] = "「#{@memo.title}」の削除が完了しました。"
    else
      flash[:notice] = "「#{@memo.title}」の削除に失敗しました。"
    end

    redirect_to "/memos/list/#{@category}/#{@mode}"
  end
end
