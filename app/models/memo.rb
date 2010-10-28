class Memo < ActiveRecord::Base

  #-------------------#
  # self.mode_choices #
  #-------------------#
  def self.mode_choices
    [ ["公開", "public"], ["非公開", "private"] ]
  end

  #--------------------#
  # self.level_choices #
  #--------------------#
  def self.level_choices
    [ ["Normal", "normal"], ["Expert", "expert"] ]
  end

  #---------------------#
  # self.user_categorys #
  #---------------------#
  def self.user_categorys( args )
    print "【 args 】>> " ; p args ;
    Memo.find( :all, :conditions => [ "category != '' AND user_id = :user_id", { :user_id => args[:user_id].to_s } ], :select => "DISTINCT category", :order => "category ASC" )
  end

  #-----------------------#
  # self.public_categorys #
  #-----------------------#
  def self.public_categorys
    Memo.find( :all, :conditions => "category != '' AND mode = 'public' ", :select => "DISTINCT category", :order => "category ASC" )
  end

  #-------------------#
  # self.mode_public? #
  #-------------------#
  def self.mode_public?( mode )
    return true if mode == "public"
    return false
  end

  #--------------------#
  # self.mode_private? #
  #--------------------#
  def self.mode_private?( mode )
    return true if mode == "private"
    return false
  end

end
