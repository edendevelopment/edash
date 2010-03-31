DASHBOARD
=========

This application is designed as an open source clone of Panic's real time dashboard application.

It currently supports build pass/fail/building messages only.

Watch http://chrismdp.github.com for updates.

Integrating with CI servers
===========================

CI Joe
------
This [blog post](http://chrismdp.github.com/2010/03/multiple-ci-joes-with-rack-and-passenger/) contains a build-hook script which you can symlink all three CI Joe hook scripts to (after-reset, build-worked, build-failed). See that post for full instructions: It's what we use and therefore fairly easy.

cruisecontrol.rb
----------------
(thanks to [Gavin Heavyside](http://twitter.com/_hgavin))

* Copy `plugins/cruisecontrol.rb/edash_notifier.rb` to `$CRUISE_DATA_ROOT/builder_plugins`
* Customise the server address and port as required
* Restart cruisecontrol.rb

Hudson
------
(thanks to [Paul Battley](http://twitter.com/threedaymonk))

* Follow the instructions on [this gist](http://gist.github.com/349022)
