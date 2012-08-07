class FindPlugin < Plugin
  requires_version '1.1.4'
end

class Find
  def self.find(path,args = {})
    extension = args.fetch(:extension,'.app')
    maxdepth = args.fetch(:max_depth,2)
    type = args.fetch(:type, 'd')
    depth = args[:depth]

    query = 'find '
    query += "\"#{path}\" "
    query += "-type #{type} " unless type == :any
    query += "-iname '*#{extension}' "
    query += " -maxdepth #{maxdepth} "
    query += " -depth #{depth} " if depth

    items = `#{query}`.chomp.split("\n").map do |item| 
      DisplayItem.new(item,File.basename(item).gsub(extension,""))
    end

    items.each{|item| yield item if block_given?}
    items
  end
end
