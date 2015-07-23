class UserToken < ActiveRecord::Base

  class << self

    def verify_token(token)
      user_token = where(token: token).first
    end

  end

end
