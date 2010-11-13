class Static < Sequel::Model
  def validate
    super
    validates_presence [:title, :body]
  end
end
