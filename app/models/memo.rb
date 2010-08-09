class Memo < ActiveRecord::Base

  def self.mode_choices
    [ ["公開", "public"], ["非公開", "private"] ]
  end

  def self.level_choices
    [ ["Normal", "normal"], ["Expert", "expert"] ]
  end

  def self.user_categorys( args )
    print "【 args 】>> " ; p args ;
    Memo.find( :all, :conditions => [ "category != '' AND user_id = :user_id", { :user_id => args[:user_id].to_s } ], :select => "DISTINCT category", :order => "category ASC" )
  end

  def self.public_categorys
    Memo.find( :all, :conditions => "category != '' AND mode = 'public' ", :select => "DISTINCT category", :order => "category ASC" )
  end

end
