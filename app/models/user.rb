class User < ActiveRecord::Base

  scope :unseen, ->{ self.where(last_seen_at: nil) }

  def self.set_all_seen
    unseen_users = User.where(last_seen_at: nil)
    require 'pry';binding.pry

    # This makes no difference: it would still result in an empty relation:
    un_unseen_users = unseen_users.load

    # This turns the ActiveRecord_Relation into an Array of the
    # retrieved objects:
    un_unseen_users = unseen_users.load.to_a
    # The upshot is that you lose the relational aspect of the collection!

    unseen_users.update_all(last_seen_at: DateTime.now)

    # This reloads the previously unseen users with the updated info:
    un_unseen_users.map(&:reload)
  end

end
