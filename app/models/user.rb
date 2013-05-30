class User < ActiveRecord::Base
  attr_accessible :email, :fbid, :uid, :is_admin
end
