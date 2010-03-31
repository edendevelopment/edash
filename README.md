DASHBOARD
=========

This application is designed as an open source clone of Panic's real time dashboard application.

It currently supports build pass/fail/building messages only.

Watch http://chrismdp.github.com for updates.

Integrating with CI servers
===========================

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
