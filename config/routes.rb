Wolfmanblog::Application.routes.draw do

  resources :statics

  # make pagination a url for caching
  get '/posts(/page/:page)' => 'posts#index', :constraints => {:page => /\d+/ }, :as => :posts

  # because next one would overide these
  post '/posts/upload' => 'posts#upload'

  # route by post id, redirected to route by permalink in controller
  get '/post/:id' => 'posts#show_by_id', :constraints => {:id => /\d+/}, :as => :postbyid

  # route by permalink
  match '/articles/:year/:month/:day/:title(.:format)' => 'posts#show', :as => :article

  resources :posts, :only => [:destroy, :edit, :update, :create, :new]


  # Adds the required routes for merb-auth using the password slice
  #slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  delete '/comments/:commentid' => "comments#destroy", :as => :delete_comment
  post '/comments/:postid' => 'comments#create', :as => :add_comment


  match '/articles/category/:name(/page/:page)' => 'posts#list_by_category', :as => :category

  # NOTE the hack to allow a dot in the tag name, and still allow pages
  match '/articles/tag/:name(/page/:page)' => "posts#list_by_tag", :as => :tag, :constraints => { :name => /[^\/]+/ }

  match '/logout' => "posts#logout"

  root :to => "posts#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
