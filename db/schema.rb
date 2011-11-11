# Database schema version: 5
Sequel.migration do
  up do
    create_table(:categories, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :text=>true
      
      index [:name], :unique=>true, :name=>:categories_name_key
    end
    
    create_table(:categories_posts) do
      primary_key :id
      Integer :post_id, :null=>false
      Integer :category_id, :null=>false
    end
    
    create_table(:comments) do
      primary_key :id
      String :name, :text=>true
      String :body, :null=>false, :text=>true
      String :email, :text=>true
      String :url, :text=>true
      String :guid, :text=>true
      Integer :post_id, :null=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
    end
    
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      String :body, :null=>false, :text=>true
      String :title, :null=>false, :text=>true
      String :author, :text=>true
      String :permalink, :text=>true
      String :guid, :null=>false, :text=>true
      TrueClass :allow_comments, :default=>true
      TrueClass :comments_closed, :default=>false
      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      
      index [:permalink], :unique=>true, :name=>:posts_permalink_key
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
      String :title, :null=>false, :text=>true
      String :body, :null=>false, :text=>true
      Integer :position, :default=>0
    end
    
    create_table(:tags, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :text=>true
      
      index [:name], :unique=>true, :name=>:tags_name_key
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
