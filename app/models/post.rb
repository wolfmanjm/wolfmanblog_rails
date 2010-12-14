class Post < Sequel::Model
  plugin :timestamps, :update_on_create => true
  plugin :validation_helpers

  one_to_many :comments, :order => :created_at
  many_to_many :tags
  many_to_many :categories

  def validate
    super
    validates_presence [:title, :body]
  end

  def before_create
    self.permalink= title.to_url if title
    self.guid= UUIDTools::UUID.random_create
    super
  end

  def to_html
    doc= RDiscount.new(convert(body))
    doc.to_html
  end

  def abstract
    ab= extract_abstract(body)
    doc= RDiscount.new(ab)
    doc.to_html
  end

  def comments_size
    Comment.filter(:post_id => id).count
  end

  def self.find_by_permalink(title)
    filter(:permalink => title).first
  end

  def categories_csv
    categories.collect{ |c| c.name}.join(',') unless id.nil?
  end

  def tags_csv
    tags.collect{ |t| t.name}.join(',') unless id.nil?
  end

  # update the categories and tags with a comma separated list
  def update_categories_and_tags(cats, tags)
    remove_all_categories
    remove_all_tags

    unless cats.empty?
      cats.split(',').each do |c|
        cat= Category.find_or_create(:name => c.strip)
        add_category(cat)
      end
    end
    unless tags.empty?
      tags.split(',').each do |t|
        tag= Tag.find_or_create(:name => t.strip)
        add_tag(tag)
      end
    end
  end

  def year
    created_at.year
  end

  def month
    created_at.month
  end

  def day
    created_at.day
  end

  # return the next post by date
  def next_post
    Post.filter('created_at > ?', created_at).order(:created_at).first
  end
  
  def previous_post
    Post.filter('created_at < ?', created_at).reverse_order(:created_at).first
  end

  private

  # convert the <typo code> tags to use syntax Highlighter
  def convert(bod)
    if bod =~ /<typo:code\s+lang="(.*)">/
      bod.gsub!(/<typo:code\s+lang="(.*)">/, "<script type='syntaxhighlighter' class='brush: \\1; gutter:true'><![CDATA[")
      bod.gsub!("</typo:code>", "]]></script>")
    end
    bod
  end

  def extract_abstract(bod)
    # get first two paragraphs
    cnt= 0
    ab= ""
    first= true
    bod.each_line do |l|
      if !first && l.chomp.empty?
        cnt+=1
      end
      first= false
      ab << l

      break if cnt >= 2
    end
    ab
  end

end
