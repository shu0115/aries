class PublicController < ApplicationController

  layout "base"

  #------#
  # list #
  #------#
  def list
    session_clear()
    
    @category = params[:id]

    conditions = Hash.new
    conditions[:mode] = "public"
    conditions[:category] = @category unless @category.blank?

    @all_public_memos = Memo.all( :conditions => conditions, :order => "category ASC, title ASC" )
    @categorys = Memo.public_categorys
  end

  #------#
  # show #
  #------#
  def show
    @category = params[:option]
    @memo = Memo.find( params[:id] )
  end

end
