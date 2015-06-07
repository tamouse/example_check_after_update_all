# Example app showing update_all confusion

In `app/models/user.rb`, the `set_all_seen` class method gathers all
the users that have not ever been seen, and then runs `update_all` to
set the current datetime.

After that, the object holding the collection is empty as it no longer
satisfies it's original condition.
