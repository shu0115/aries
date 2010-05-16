class Memo < ActiveRecord::Base

  def self.mode_choices
    [ ["公開", "public"], ["非公開", "private"] ]
  end

  def self.level_choices
    [ ["Normal", "normal"], ["Expert", "expert"] ]
  end

  def self.categorys
    Memo.find( :all, :conditions => "category != ''", :select => "DISTINCT category", :order => "category ASC" )
  end

  def self.public_categorys
    Memo.find( :all, :conditions => "category != '' AND mode = '公開' ", :select => "DISTINCT category", :order => "category ASC" )
  end

end
