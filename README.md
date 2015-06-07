# Example app showing update_all confusion

In `app/models/user.rb`, the `set_all_seen` class method gathers all
the users that have not ever been seen, and then runs `update_all` to
set the current datetime.

After that, the object holding the collection is empty as it no longer
satisfies it's original condition.

## Sample test scenario

```
/home/vagrant/.rvm/rubies/ruby-2.2.0/bin/ruby -I/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/lib:/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-support-3.2.2/lib /home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb

StaticPagesController
  GET #index
    returns http success

User
  #set_all_seen
    when using count
      finds 20 users unseen
      set_all_seen returns 20 (FAILED - 1)
      set_all_seen_with_update returns 20 (FAILED - 2)
      set_all_seen_as_array returns 20
    when using size
      finds 20 users unseen
      set_all_seen returns 20
      set_all_seen_with_update returns 20
      set_all_seen_as_array returns 20

Failures:

  1) User#set_all_seen when using count set_all_seen returns 20
     Failure/Error: expect(User.set_all_seen.count).to eq(20)

       expected: 20
            got: 0

       (compared using ==)
     # ./spec/models/user_spec.rb:15:in `block (4 levels) in <top (required)>'

  2) User#set_all_seen when using count set_all_seen_with_update returns 20
     Failure/Error: expect(User.set_all_seen_with_update.count).to eq(20)

       expected: 20
            got: 0

       (compared using ==)
     # ./spec/models/user_spec.rb:19:in `block (4 levels) in <top (required)>'

Finished in 0.98443 seconds (files took 7.5 seconds to load)
9 examples, 2 failures

Failed examples:

rspec ./spec/models/user_spec.rb:14 # User#set_all_seen when using count set_all_seen returns 20
rspec ./spec/models/user_spec.rb:18 # User#set_all_seen when using count set_all_seen_with_update returns 20

/home/vagrant/.rvm/rubies/ruby-2.2.0/bin/ruby
-I/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/lib:/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-support-3.2.2/lib
/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/exe/rspec
--pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb failed
```

## Conclusion

Setting up the ActiveRecord::Relation and then calling `update_all` or
`update` does not actually change the relation. The next time it is
invoked, the relation is evaluation, in this case correctly finding no
unseen users.

Converting the relation into an array seems like the only way to
preserve that initial collection, odd though it seems. It still feels
wrong, but I haven't reached an alternative.

Finally, using `size` instead of `count` AND eager loading the
relation works:

``` ruby
  def self.set_all_seen
    unseen_users = User.where(last_seen_at: nil)

    un_unseen_users = unseen_users.load

    unseen_users.update_all(last_seen_at: DateTime.now)

    un_unseen_users
  end
```

## Contributors

Thanks to `@chridal` on `#ruby@irc.freenode.net` for posing the
problem.

**HUGE** shout-out to `@sevenseacat` for pointing out the problem with
using `.count` instead of `.size`.
