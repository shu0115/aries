class Memo < ActiveRecord::Base

  def self.categorys
    Memo.find( :all, :conditions => "category != ''", :select => "DISTINCT category", :order => "category ASC" )
  end

  def self.mode_choices
    [ ["Private", "Private"], ["Public", "Public"] ]
  end

  def self.level_choices
    [ ["Normal", "Normal"], ["Expert", "Expert"] ]
  end

end
