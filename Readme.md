This is a basic Blogging engine, specifically written to host
blog.wolfman.com

Originally written in Merb and now ported to Rails 3.

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

Recent Changes from the Merb version
------------------------------------

* index page shows the first two paragraphs of each article
* uses the sytaxhighlighter javascript to highlight code
* formats the comments better without allowing markup
* fixes the paging for tags and categories
* rather than using will_paginate just has Older/Newer posts links
* uses a javascript based challenge/response login scheme for the admin
* add upload file to upload YAML formatted blog entries