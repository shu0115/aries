class User < ActiveRecord::Base

  def self.login( args )
    login_user = User.find( :first, :conditions => args )
    unless login_user.blank?
      return login_user.id, login_user.name
    else
      return nil, nil
    end
  end

end
