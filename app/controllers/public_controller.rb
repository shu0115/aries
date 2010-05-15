class PublicController < ApplicationController

  layout "base"

  #------#
  # list #
  #------#
  def list
    @category = params[:id]

    conditions = Hash.new
    conditions[:mode] = "公開"
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
