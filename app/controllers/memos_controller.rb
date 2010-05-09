class MemosController < ApplicationController

  #-------#
  # index #
  #-------#
  def index
    session[:search_category] = params[:option] unless params[:option].blank?
    if params[:option].blank? and params[:id].to_s != "none"
      category = session[:search_category]
    else
      category = params[:option]
    end
    
    conditions = "category = '#{category}'" unless category.blank?
    @all_memos = Memo.all( :conditions => conditions, :order => "category ASC, title ASC" )
    @categorys = Memo.categorys
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
    @memo = Memo.find( params[:id] )
  end

  #-----#
  # new #
  #-----#
  def new
    @memo = Memo.new
    @categorys = Memo.categorys
  end

  #------#
  # edit #
  #------#
  def edit
    @memo = Memo.find( params[:id] )
    @categorys = Memo.categorys
  end

  #--------#
  # create #
  #--------#
  def create
    @memo = Memo.new( params[:memo] )
    @memo.category = "None" if @memo.category.blank?

    if @memo.save
      flash[:notice] = 'メモの新規作成が完了しました。'
      redirect_to '/memos/index/none'
    else
      flash[:notice] = 'メモの新規作成に失敗しました。'
      redirect_to '/memos/new'
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @memo = Memo.find( params[:id] )
    update_params = params[:memo]
    update_params[:category] = "None" if update_params[:category].blank?

    if @memo.update_attributes( update_params )
      flash[:notice] = 'メモの更新が完了しました。'
      redirect_to "/memos/show/#{@memo.id}"
    else
      flash[:notice] = 'メモの更新に失敗しました。'
      redirect_to "/memos/edit/#{@memo.id}"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    @memo = Memo.find( params[:id] )

    if @memo.destroy
      flash[:notice] = 'メモの削除が完了しました。'
    else
      flash[:notice] = 'メモの削除に失敗しました。'
    end

    redirect_to '/memos/index/none'
  end
end
