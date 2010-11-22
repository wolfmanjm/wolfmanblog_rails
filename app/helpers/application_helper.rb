module ApplicationHelper
  def sidebar(name)
    render_cell :sidebar, name
  end

  def permalink(post, opts={})
    article_path(post.year, post.month, post.day, post.permalink, opts)
  end

  def absolute_permalink(post, opts={})
    article_url(post.year, post.month, post.day, post.permalink, opts)
  end

  def authenticated?
    session[:logged_in]
  end

  def delete_button(url, text, opts={})
    link_to text, url, :confirm => 'Are you sure?', :method => :delete
  end

  # Helpers for easy usage of SyntaxHighlighter2 in your views.

  SH2_BRUSHES = {
    'java' => 'Java',
    'js jscript javascript' =>'JScript',
    'groovy' => 'Groovy',
    'ruby' => 'Ruby',
    'cpp c' => 'Cpp',
    'erlang' => 'Erlang',
    'plain text' => 'Plain',
    'xml' => 'Xml'
  }

  SH2_THEMES = {
    :default => 'Default',
    :django => 'Django',
    :emacs => 'Emacs',
    :eclipse => 'Eclipse',
    :midnight => 'Midnight',
    :rdark => 'RDark',
    :fade_to_gray => 'FadeToGrey'
  }

  def include_syntax_highlighter_assets(args = {})
    theme = args[:theme] || :default

    output ||= []
    output << javascript_include_tag('syntaxhighlighter/shCore')

    SH2_BRUSHES.values.each { |v| output << javascript_include_tag("syntaxhighlighter/shBrush#{v}") }

#    output << javascript_include_tag('syntaxhighlighter/shAutoloader')

    output << '<script type="text/javascript">'

#    output << 'SyntaxHighlighter.autoloader('
#    l= []
#    SH2_BRUSHES.each { |k,v| l << "'#{k} /javascripts/syntaxhighlighter/shBrush#{v}.js'" }
#    output << l.join(",\n")
#    output << ');'

    output << 'SyntaxHighlighter.all(); </script>'

    output << stylesheet_link_tag('syntaxhighlighter/shCore')
    output << stylesheet_link_tag("syntaxhighlighter/shTheme#{SH2_THEMES[theme]}")
    output.join("\n")
  end

  def format_comment(body)
    # replace all tags with entities so they display but don't do anything
    b=  body.gsub('<', '&lt;').gsub('>', '&gt;')

    # replace all indentation with nbsp and newlines with br
    b= b.gsub(/(^\s+)|(\n\s+)/) { |a| a.gsub(' ', '&nbsp;') }
    b= b.gsub(/\n/, "<br />\n")
    b
  end


end
