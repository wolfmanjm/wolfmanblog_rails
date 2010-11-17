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

Recent Changes from the Merb version
------------------------------------

* index page shows the first two paragraphs of each article
* uses the sytaxhighlighter javascript to highlight code
* formats the comments better without allowing markup
* fixes the paging for tags and categories
* rather than using will_paginate just has Older/Newer posts links

