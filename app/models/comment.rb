class Comment < Sequel::Model
  plugin :timestamps
  many_to_one :post

  def validate
    super
    validates_presence :body
  end

  def before_create
    self.guid= UUID.random_create
    super
  end

  def self.delete_comments_for_post(id)
    filter(:post_id => id).delete
  end
end
