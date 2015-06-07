# Example app showing update_all confusion

In `app/models/user.rb`, the `set_all_seen` class method gathers all
the users that have not ever been seen, and then runs `update_all` to
set the current datetime.

After that, the object holding the collection is empty as it no longer
satisfies it's original condition.

## Sample test scenario

```
/home/vagrant/.rvm/rubies/ruby-2.2.0/bin/ruby -I/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/lib:/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-support-3.2.2/lib /home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb
..FF.

Failures:

  1) User#set_all_seen returns 20 users as unseen
     Failure/Error: expect(User.set_all_seen.count).to eq(20)

       expected: 20
            got: 0

       (compared using ==)
     # ./spec/models/user_spec.rb:14:in `block (3 levels) in <top (required)>'

  2) User#set_all_seen returns 20 users as unseen
     Failure/Error: expect(User.set_all_seen_with_update.count).to eq(20)

       expected: 20
            got: 0

       (compared using ==)
     # ./spec/models/user_spec.rb:18:in `block (3 levels) in <top (required)>'

Finished in 0.59987 seconds (files took 7.25 seconds to load)
5 examples, 2 failures

Failed examples:

rspec ./spec/models/user_spec.rb:13 # User#set_all_seen returns 20 users as unseen
rspec ./spec/models/user_spec.rb:17 # User#set_all_seen returns 20 users as unseen

/home/vagrant/.rvm/rubies/ruby-2.2.0/bin/ruby -I/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/lib:/home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-support-3.2.2/lib /home/vagrant/.rvm/gems/ruby-2.2.0/gems/rspec-core-3.2.3/exe/rspec --pattern spec/\*\*\{,/\*/\*\*\}/\*_spec.rb failed
```

## Conclusion

Setting up the ActiveRecord::Relation and then calling `update_all` or
`update` does not actually change the relation. The next time it is
invoked, the relation is evaluation, in this case correctly finding no
unseen users.

Converting the relation into an array seems like the only way to
preserve that initial collection, odd though it seems. It still feels
wrong, but I haven't reached an alternative.
