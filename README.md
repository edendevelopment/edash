DASHBOARD
=========

This application is designed as an open source clone of Panic's real time dashboard application.

Watch http://chrismdp.github.com for updates.

Getting Started
===============

Installing and running
----------------------

Here's a minimal set of steps to get it running:

    gem install sinatra haml sass json pstore md5 eventmachine em-http-request harmony
    git clone git://github.com/edendevelopment/edash.git
    cd edash
    git submodule update --init
    # runs the websocket server, make sure port 8080 is readable from where you are. Use nohup to run as a daemon.
    scripts/server &
    # Run rackup in place, or use your favourite rack-compatible server
    rackup &
  
Updating edash with build messages
----------------------------------

    curl -d "project=<project>" -d "status=<pass|fail|building>" [-d "author=name <email>"] -- http://localhost:9292/build

Updating edash with project process messages
--------------------------------------------

    curl -d "project=<project>" -d "progress=[[\"started\", \"10\"],[\"finished\",\"20\"]]" -- http://localhost:9292/progress

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
