class MemosController < ApplicationController

  #-------#
  # index #
  #-------#
  def index
    @memos = Memo.all
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
  end

  #------#
  # edit #
  #------#
  def edit
    @memo = Memo.find( params[:id] )
  end

  #--------#
  # create #
  #--------#
  def create
    @memo = Memo.new( params[:memo] )

    if @memo.save
      flash[:notice] = 'メモの新規作成が完了しました。'
      redirect_to '/memos/index'
    else
      redirect_to '/memos/new'
    end
  end

  #--------#
  # update #
  #--------#
  def update
    @memo = Memo.find( params[:id] )

    if @memo.update_attributes( params[:memo] )
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

    redirect_to '/memos/index'
  end
end
