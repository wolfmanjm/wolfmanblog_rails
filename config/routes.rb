Wolfmanblog::Application.routes.draw do

  resources :statics

  # make pagination a url for caching
  get '/posts(/page/:page)' => 'posts#index', :constraints => {:page => /\d+/ }, :as => :posts
  get '/posts/page/:page' => 'posts#index', :constraints => {:page => /\d+/ }, :as => :postspage

  # because next one would overide these
  post '/posts/upload' => 'posts#upload'

  # route by post id, redirected to route by permalink in controller
  get '/post/:id' => 'posts#show_by_id', :constraints => {:id => /\d+/}, :as => :postbyid
  get '/posts/:id' => 'posts#show_by_id', :constraints => {:id => /\d+/}


  resources :posts, :only => [:destroy, :edit, :update, :create, :new]


  get '/comments' => "comments#index", :defaults => { :format => 'rss' }
  delete '/comments/:commentid' => "comments#destroy", :as => :delete_comment
  post '/comments/:postid' => 'comments#create', :as => :add_comment


  match '/articles/category/:name(/page/:page)' => 'posts#list_by_category', :as => :category, :constraints => { :name => /[^\/]+/ }

  # NOTE the hack to allow a dot in the tag name, and still allow pages
  match '/articles/tag/:name(/page/:page)' => "posts#list_by_tag", :as => :tag, :constraints => { :name => /[^\/]+/ }

  # route by permalink
  match '/articles/:year/:month/:day/:title(.:format)' => 'posts#show', :as => :article

  post '/login' => "users#attempt_login"
  match '/login' => "users#login"
  match '/logout' => "users#logout"

  # old rss feed
  match "/xml/rss20/feed.xml" => "posts#index", :defaults => { :format => 'rss' }
  match "/xml/atom10/feed.xml" => "posts#index", :defaults => { :format => 'atom' }
  match "/xml/rss20/comments/feed.xml" =>  "comments#index", :defaults => { :format => 'rss' }
    
  root :to => "posts#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
