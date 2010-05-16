class MemosController < ApplicationController

  layout "base"

  #------#
  # list #
  #------#
  def list
    @category = params[:id]
    @mode = params[:option]
    @mode = "公開" if @mode.to_s == "public"
    @mode = "非公開" if @mode.to_s == "private"
    
    conditions = Hash.new
    conditions[:category] = @category if ( !@category.blank? and @category.to_s != "all" )
    conditions[:mode] = @mode unless @mode.blank?

    @all_memos = Memo.all( :conditions => conditions, :order => "mode ASC, category ASC, title ASC" )
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
      redirect_to "/memos/show/#{@memo.id}/#{@category}"
    else
      flash[:notice] = "「#{@memo.title}」の新規作成に失敗しました。"
      redirect_to "/memos/new/#{@category}"
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
      redirect_to "/memos/show/#{@memo.id}/#{@memo.category}"
    else
      flash[:notice] = "「#{@memo.title}」の更新に失敗しました。"
      redirect_to "/memos/edit/#{@memo.id}/#{@memo.category}"
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

    redirect_to "/memos/list/#{@category}"
  end
end
