class PublicController < ApplicationController

  layout "base"

  #------#
  # list #
  #------#
  def list
    # セッションクリーニング
    session_clear()
    
    @category = params[:category]
    @search_word = params[:search_word]
    @search_type = params[:search_type]
    
    # 検索条件
    conditions_text = ""
    conditions_text += "mode = :mode"
    conditions_text += " AND category = :category" unless @category.blank?

    conditions = Hash.new
    conditions[:mode] = "public"
    conditions[:category] = @category unless @category.blank?

    # メモ検索
    if @search_type == "note"
      conditions_text += " AND note LIKE :search_word" unless @search_word.blank?
      conditions[:search_word] = "%#{@search_word}%" unless @search_word.blank?
      @all_public_memos = Memo.all( :conditions => [ conditions_text, conditions ], :order => "category ASC, title ASC" )
      @note_checked = true
    elsif @search_type == "title"
      conditions_text += " AND title LIKE :search_word" unless @search_word.blank?
      conditions[:search_word] = "%#{@search_word}%" unless @search_word.blank?
      @all_public_memos = Memo.all( :conditions => [ conditions_text, conditions ], :order => "category ASC, title ASC" )
      @title_checked = true
    else
      flash[:notice] = "検索タイプを選択して下さい。" if !@search_word.blank? and @search_type.blank?
      @all_public_memos = Memo.all( :conditions => conditions, :order => "category ASC, title ASC" )
    end

    @categorys = Memo.public_categorys
    @title_checked = true if @title_checked.blank?
  end

  #------#
  # show #
  #------#
  def show
    @category = params[:option]
    @memo = Memo.find( params[:id] )
  end
  
  #--------#
  # search #
  #--------#
  def search
    @search_word = params[:search_word]
    @search_type = params[:search_type]

    # 検索条件
    conditions_text = ""
    conditions_text += "mode = :mode"
    conditions_text += " AND category = :category" unless @category.blank?

    conditions = Hash.new
    conditions[:mode] = "public"
    conditions[:category] = @category unless @category.blank?
    conditions[:search_word] = "%#{@search_word}%"

    # メモ検索
    if @search_type == "note"
      conditions_text += " AND note LIKE :search_word"
      @all_public_memos = Memo.all( :conditions => [ conditions_text, conditions ], :order => "category ASC, title ASC" )
      @note_checked = true
    else
      conditions_text += " AND title LIKE :search_word"
      @all_public_memos = Memo.all( :conditions => [ conditions_text, conditions ], :order => "category ASC, title ASC" )
      @title_checked = true
    end

    @categorys = Memo.public_categorys
  end
  
end
