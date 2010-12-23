Factory.define :post do |p|
  p.sequence(:title) { |n| "post #{n}" }
  p.body 'This is the body'
end

