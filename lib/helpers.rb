include Nanoc::Helpers::Rendering
include Nanoc::Helpers::ChildParent

def things
    blk = -> { newest_first(@items.find_all("/**/*").select{|i| i[:published]}) }
    if @items.frozen?
        @things ||= blk.call
    else
        blk.call
    end
end

def link_to item, text=nil
    text = item[:title] if text.nil?
    "<a href=\"#{link_for(item)}\">#{text}</a>"
end

def calculate_tags
    @items.select{|i| i[:tags]}.map{|i| i[:tags]}.flatten.uniq.sort
end

def tags
    calculate_tags
end

def link_for item
    if item[:url]
        item[:url]
    else
        item.path
    end
end

def tags_for item, link=true
    item[:tags].map do |tag|
        if link
            "<a href=\"/##{tag}\">#{tag}</a>"
        else
            tag
        end
    end.join(", ")
end

def lang_for item
    if item[:tags] and item[:tags].include? "de"
        "de"
    else
        "en"
    end
end

def abstract_for item
	if item[:abstract]
        item[:abstract]
    elsif item[:subtitle]
        item[:subtitle]
    else
        content = item.raw_content.dup
        content.gsub!(/!\[([^\]]*)\]\([^)]*\)/,"") # remove images
        content.gsub!(/\[([^\]]*)\]\([^)]*\)/,"\\1") # replace links with link text
        content.gsub!(/[*"]/,"") # remove italic and bold markers and quotations
        content.strip!
        abstract = content[/^[[:print:]]{20,256}[.…!?:*]/] || item[:title]
    end
end

def thumbnail_for item
	thumbnail = if item[:thumbnail]
                    @items[item[:thumbnail]]
                else
					nil
				end

    if thumbnail && thumbnail.reps[:thumbnail]
        thumbnail.reps[:thumbnail].path
	else
		raise "error: could not find thumbnail rep of "+item.identifier.to_s
    end
end

def minithumbnail_for item
	thumbnail = if item[:thumbnail]
                    @items[item[:thumbnail]]
                else
					nil
				end

    if thumbnail && thumbnail.reps[:minithumbnail]
        thumbnail.reps[:minithumbnail].path
	else
		raise "error: could not find minithumbnail rep of "+item.identifier.to_s
    end
end

def with_tag tag
    things.select do |item|
        item[:tags] and item[:tags].include? tag
    end
end

def domain
    "http://metakiki.net/"
end

def box(items)
    ret = "<div class=\"boxes\">"
    items.each do |item|
        ret << render("/box.*", {:item => item})
    end
    ret << "</div>"
    ret
end

def newest_first(items)
    items.select{|i| i[:updated] || i[:published] }.sort_by{|i| i[:updated] || i[:published]}.reverse
end
