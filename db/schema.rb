Sequel.migration do
  up do
    create_table(:categories, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :text=>true
      
      index [:name], :name=>:categories_name_key, :unique=>true
    end
    
    create_table(:categories_posts) do
      primary_key :id
      Integer :post_id, :null=>false
      Integer :category_id, :null=>false
    end
    
    create_table(:comments) do
      primary_key :id
      String :name, :text=>true
      String :body, :text=>true, :null=>false
      String :email, :text=>true
      String :url, :text=>true
      String :guid, :text=>true
      Integer :post_id, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
    end
    
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      String :body, :text=>true, :null=>false
      String :title, :text=>true, :null=>false
      String :author, :text=>true
      String :permalink, :text=>true
      String :guid, :text=>true, :null=>false
      TrueClass :allow_comments, :default=>true
      TrueClass :comments_closed, :default=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:permalink], :name=>:posts_permalink_key, :unique=>true
    end
    
    create_table(:posts_tags) do
      primary_key :id
      Integer :post_id, :null=>false
      Integer :tag_id, :null=>false
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:statics) do
      primary_key :id
      String :title, :text=>true, :null=>false
      String :body, :text=>true, :null=>false
      Integer :position, :default=>0
    end
    
    create_table(:tags, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :text=>true
      
      index [:name], :name=>:tags_name_key, :unique=>true
    end
    
    create_table(:users) do
      primary_key :id
      String :name, :text=>true
      String :crypted_password, :text=>true
      String :salt, :text=>true
      TrueClass :admin
    end
  end
  
  down do
    drop_table(:categories, :categories_posts, :comments, :posts, :posts_tags, :schema_info, :statics, :tags, :users)
  end
end
