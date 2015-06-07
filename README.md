# Example app showing update_all confusion

In `app/models/user.rb`, the `set_all_seen` class method gathers all
the users that have not ever been seen, and then runs `update_all` to
set the current datetime.

After that, the object holding the collection is empty as it no longer
satisfies it's original condition.

## Sample test scenario with pry session

```

$ clear;rake

/home/vagrant/.rvm/rubies/ruby-2.2.0/bin/ruby -I/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/lib:/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-support-3.2.2/lib /home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb
..
From: /vagrant/rubystuff/railsapps/examples/check_after_update_all/app/models/user.rb @ line 8 User.set_all_seen:

     5: def self.set_all_seen
     6:   unseen_users = User.where(last_seen_at: nil).load
     7:   require 'pry';binding.pry
 =>  8:   unseen_users.update_all(last_seen_at: DateTime.now)
     9:   unseen_users
    10: end

[1] pry(User)> unseen_users.count
=> 20
[2] pry(User)> next

From: /vagrant/rubystuff/railsapps/examples/check_after_update_all/app/models/user.rb @ line 9 User.set_all_seen:

     5: def self.set_all_seen
     6:   unseen_users = User.where(last_seen_at: nil).load
     7:   require 'pry';binding.pry
     8:   unseen_users.update_all(last_seen_at: DateTime.now)
 =>  9:   unseen_users
    10: end

[2] pry(User)> unseen_users.count
=> 0
[3] pry(User)> quit
F

Failures:

  1) User#set_all_seen returns 20 users as unseen
     Failure/Error: expect(User.set_all_seen.count).to eq(20)

       expected: 20
            got: 0

       (compared using ==)
     # ./spec/models/user_spec.rb:14:in `block (3 levels) in <top (required)>'

Finished in 16.12 seconds (files took 6.94 seconds to load)
3 examples, 1 failure

Failed examples:

rspec ./spec/models/user_spec.rb:13 # User#set_all_seen returns 20 users as unseen

/home/vagrant/.rvm/rubies/ruby-2.2.0/bin/ruby -I/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/lib:/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-support-3.2.2/lib /home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb failed

```
