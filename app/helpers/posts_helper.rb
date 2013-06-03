module PostsHelper
  def cache_list_add(item)
    @cache_list = Rails.cache.read 'cache-list'
    if !@cache_list.is_a? Array
      @cache_list = []
    end

    if !@cache_list.include? item
      @cache_list.push item
      Rails.cache.write 'cache-list', @cache_list
    end
  end

  def self.find_break_points(text)
	  count = position = 0
	  text.scan(/./).each do |c|
	    count += 1
	    position += 1
	    if count == 40
	      if c == ' '
	        text[position] = '||'
	      else
	        point = [text.index(' ', position - 1), text.rindex(' ', position - 1)].min
	        text[point] =  '||'
	      end
	      count = 1
	    end
	  end

	  text
  end
  def self.image_writer(path, the_top_text, the_bottom_text)
  	path = Rails.root.to_s + path
  	path = path.gsub(/\?.*/i, '')

    font_path = Rails.root.to_s + '/DINComp-Medium.ttf'

    if !the_top_text.empty?
      top_text = self.find_break_points(the_top_text)
      top_text = 'Adopt me because...||' + top_text
      top_joined = top_text.split('||')
      top_text = top_joined.join("\n")
      top_height = (top_joined.count * 25) + 10

      # Top text box
      system '''
        convert ''' + path + ''' \
          -strokewidth 0 \
          -fill "rgba( 0, 0, 0 , 0.35 )" \
          -draw "rectangle 0,0 450,''' + top_height.to_s + ''' " \
        ''' + path + '''
      '''

      # Top text
      system '''
        convert ''' + path + ''' \
          -gravity North \
          -font ''' + font_path + ''' \
          -pointsize 25 \
          -size 450x \
          -interline-spacing -13 \
          -fill white \
            -annotate +0-0 "''' + top_text + '''" \
        ''' + path + '''
      '''
      end

      if !the_bottom_text.empty?
        bottom_text = self.find_break_points(the_bottom_text)
        bottom_text = 'Adopt me because...||' + bottom_text
        bottom_joined = bottom_text.split('||')
        bottom_text = bottom_joined.join("\n")
        bottom_height = (bottom_joined.count * 25) + 10
      # Bottom text box
      system '''
        convert ''' + path + ''' \
          -strokewidth 0 \
          -fill "rgba( 0, 0, 0 , 0.35 )" \
          -draw "rectangle 450,450 0,''' + (450 - (bottom_height + 6)).to_s + '''" \
        ''' + path + '''
      '''

      # Bottom text
      system '''
        convert ''' + path + ''' \
          -gravity South \
          -font ''' + font_path + ''' \
          -pointsize 25 \
          -size 450x \
          -interline-spacing -13 \
          -fill white \
            -annotate +0-0 "''' + bottom_text + '''" \
        ''' + path + '''
      '''
    end
  end

  module Scripts
    def self.count
      Post.all.count
    end
    def self.latest
      Post.where(:filter => false).limit(10).last!.created_at
    end
  end
end
