class Memo < ActiveRecord::Base

  def self.categorys
    Memo.find( :all, :conditions => "category != ''", :select => "DISTINCT category", :order => "category ASC" )
  end

  def self.mode_choices
    [ ["非公開", "非公開"], ["公開", "公開"] ]
  end

  def self.level_choices
    [ ["Normal", "Normal"], ["Expert", "Expert"] ]
  end

end
