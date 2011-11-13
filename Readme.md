This is a basic Blogging engine, specifically written to host
blog.wolfman.com

Originally written in Merb and now ported to Rails 3.1.1

Uses HAML as the rendering engine and Sequel as the ORM.

The sidebar components (ads, tags, categories etc) use cells, where
each sidebar component is an action in the cell controller, and has a
view for each sidebar component, then the sidebar components (ie
cells) are listed in the order they should appear in the global
layout. This is ported from Merb parts.

It has RSS feeds for comments and articles.

Has a simple admin mode which allows the admin to delete posts or
comments, and to upload new articles.

Has a ridiculously simple scheme for stopping spambots, which actually
seems to work very well.

To login as admin add a user to the users table, write the hashed
password by running...

      > rails console
      irb> User.new_password('your username', 'your password') 

Then do /login and type in the username and password, what happens is
the javascript will create an auth token from the supplied nonce in
the login form and the hashed password and send that to the server,
which checks the auth token.

I found that the builtin Digest authentication doesn't work when
running passenger under Apache, as the latter stops the authenticaiton
headers getting to the rails app.

The blogs articles can be written using your favorite text editor
locally then uploaded as a YAML file. The format of the YAML file is...

      title: The title of the article
      categories: [Rails]
      keywords: javascript authentication
      --- |

      The body of the article in BlueCloth format goes here

Code can be formatted by putting it in between

      <typo:code lang="ruby">
	  your unformatted code goes here
      </typo:code>

and it will be formatted by the Highlight javascript code.


Spambot detection
-----------------

There are three levels of spambot detection...

1. Two checkboxes are presented saying are you a spambot, and the no
must be checked. This fools most spambots.

2. If [Redis](http://redis.io/) is installed then there is a Rack
Middlewarte component that looks for known mal formed URLs that
spambots tend to use, and puts the IP address in a blacklist stored by
Redis. If a request comes in from a blacklisted IP address they get a
blank page.

3. There is a hidden field called URL, that normal users won't see,
but spambots do see it as they don't parse hidden fields, if anything
is entered in the url field then the IP address is put on the Redis
blacklist as above and the comment is ignored. This tends to blacklist
most spambots as the whole reason they exist is to get their URL out
there and they always fill in the url field hidden or not.

If Redis is not running then 2 and 3 are turned off automatically.

Recent Changes from the Merb version
------------------------------------

* index page shows the first two paragraphs of each article
* uses the sytaxhighlighter javascript to highlight code
* formats the comments better without allowing markup
* fixes the paging for tags and categories
* rather than using will_paginate just has Older/Newer posts links
* uses a javascript based challenge/response login scheme for the admin
* add upload file to upload YAML formatted blog entries
* use specs to test instead of cucumber
* added spambot honeypot field
