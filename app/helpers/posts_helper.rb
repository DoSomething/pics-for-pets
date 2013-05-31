module PostsHelper
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

    top_text = self.find_break_points(the_top_text)
    bottom_text = self.find_break_points(the_bottom_text)

    top_joined = top_text.split('||')#.map(&:upcase)
    top_text = top_joined.join("\n")
    top_height = (top_joined.count * 25) + 10

    bottom_joined = bottom_text.split('||')#.map(&:upcase)
    bottom_text = bottom_joined.join("\n")
    bottom_height = (bottom_joined.count * 25) + 10

    font_path = Rails.root.to_s + '/DINComp-Medium.ttf'

    if !top_text.empty?
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

    if !bottom_text.empty?
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
