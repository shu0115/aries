class Memo < ActiveRecord::Base

  def self.mode_choices
    [ ["Private", "Private"], ["Public", "Public"] ]
  end

  def self.level_choices
    [ ["Normal", "Normal"], ["Expert", "Expert"] ]
  end

end
