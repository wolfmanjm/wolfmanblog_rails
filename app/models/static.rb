class Static < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:title, :body]
  end
end
