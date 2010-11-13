Wolfmanblog::Application.routes.draw do

  resources :statics

  # make pagination a url for caching
  match '/posts(/page/:page)' => 'posts#index', :constraints => {:page => /\d+/ }, :as => :posts

  # because next one would overide this
  match '/posts/new' => 'posts#new'

  # route by post id, redirected to route by permalink in controller
  match '/posts/:id(.:format)' => 'posts#show_by_id', :as => :post

  # route by permalink
  match '/articles/:year/:month/:day/:title(.:format)' => 'posts#show', :as => :article

  # RESTful routes, NOTE some of the post resources are overridden above
  #resources :posts
  #resources :statics
  match '/posts/:id' => 'posts#delete', :as => :delete_post, :constraints => {:method => 'delete'}
  match '/posts/:id/edit' => 'posts#edit', :as => :edit_post, :constraints => {:method => 'get'}
  match '/posts/new' => 'posts#new', :as => :new_post, :constraints => {:method => 'get'}


  match '/posts/upload' => 'posts#upload', :constraints => {:method => 'post'}, :as => :upload_post

  # Adds the required routes for merb-auth using the password slice
  #slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  match '/comments/:commentid' => "comments#destroy", :as => :delete_comment, :constraints => {:method => 'delete'}
  match '/comments/:postid' => 'comments#create', :as => :add_comment, :constraints => {:method => 'post'}
#  match("/comments(\.:format)").to(:controller => "comments", :action => "index").name(:comments)

  match '/articles/category/:name(/page/:page)' => 'posts#list_by_category', :as => :category

  # NOTE the hack to allow a dot in the tag name, and still allow pages
  match '/articles/tag/:name(/page/:page)' => "posts#list_by_tag", :as => :tag, :constraints => { :name => /[^\/]+/ }

  match '/logout' => "posts#logout"
  match '/test' => "posts#delete"


  root :to => "posts#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
