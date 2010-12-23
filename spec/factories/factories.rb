Factory.define :post do |p|
  p.sequence(:title) { |n| "post #{n}" }
  p.sequence(:body) { |n| "This is the body #{sprintf("%02d", n)}" }
end

Factory.define :tagged_post, :class => Post do |p|
  p.title "post 1"
  p.body "This is the body 1"
  p.after_create { |x| x.update_categories_and_tags("cat1,cat2", "tag1,tag2") }
end

Factory.define :user do |u|
  u.name "testuser"
  u.crypted_password "12f0d0cf9d59500b89677e3f9f037aaa993979dc"
end

Factory.define :comment do |c|
  c.association :post
  c.body "test comment 1"
  c.name "commenter name"
end
