class User < ActiveRecord::Base

  scope :unseen, ->{ self.where(last_seen_at: nil) }

  def self.set_all_seen
    unseen_users = User.where(last_seen_at: nil)

    # This makes no difference: it would still result in an empty relation:
    un_unseen_users = unseen_users.load

    unseen_users.update_all(last_seen_at: DateTime.now)

    un_unseen_users
  end

  def self.set_all_seen_as_array
    unseen_users = User.where(last_seen_at: nil)

    # This turns the ActiveRecord_Relation into an Array of the
    # retrieved objects:
    un_unseen_users = unseen_users.load.to_a
    # The upshot is that you lose the relational aspect of the collection!

    unseen_users.update_all(last_seen_at: DateTime.now)

    # This reloads the previously unseen users with the updated info:
    un_unseen_users.map(&:reload)
  end

  def self.set_all_seen_with_update
    unseen_users = User.where(last_seen_at: nil)

    people_update = unseen_users.pluck(:id).map do |person_id|
      [person_id, { last_seen_at: DateTime.now }]
    end.to_h

    # Using update instead of update_all
    self.update(people_update.keys, people_update.values)
    # This also does not work. unseen_users is still reevaluated.

    unseen_users
  end


end
