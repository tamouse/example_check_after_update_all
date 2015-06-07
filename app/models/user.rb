class User < ActiveRecord::Base

  scope :unseen, ->{ self.where(last_seen_at: nil) }

  def self.set_all_seen
    unseen_users = User.where(last_seen_at: nil).load
    require 'pry';binding.pry
    unseen_users.update_all(last_seen_at: DateTime.now)
    unseen_users
  end

end
