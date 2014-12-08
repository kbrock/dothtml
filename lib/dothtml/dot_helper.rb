require "tilt"
require 'nokogiri'
require 'set'

class DotHelper
  def initialize(source)
    @source = source
  end

  def dom
    Nokogiri::XML.parse(File.read(source))
  end

  def doc
    doc ||= dom(@source)
  end

  def extractTitle
    doc.css("title").first.content()
  end

  # this currently has too many limitations
  # working on making this more friendly
  # assume unique list of filenames
  def images
    embedded_images = Set.new

    defs = doc.create_element("def")
    namespace = defs.namespace

    # assuming the images are the correct size, declare their size
    doc.css("image").each do |img|
      #STDERR.puts img.attributes.inspect
      file_name = img.attributes["href"].value
      id = file_name.split(".").first.split("/").last
      if file_name =~ /\.svg$/ && ! embedded_images.include?(file_name)
        src = dom(file_name).at("svg")
        g = doc.create_element("g", id: id,
          width: src["width"], height: src["height"])
        # probably not necessary
        g.namespace = namespace
        # this botches their namespace
        g.add_child(src.children)
        g.children.each { |ch| ch.namespace = namespace }
        defs.add_child(g)
        embedded_images << file_name
      end

      img.name="use"
      img.attributes["href"].value="##{id}"
      #img.attributes["width"].remove
      #img.attributes["height"].remove
      #img.attributes["preserveAspectRatio"].remove
    end
    defs
  end

  def embed_images
    doc.at("svg").children.before(images)
  end

  def write(file_name, template_name, locals)
    File.write(file_name, Tilt.new(template_name).render(binding, locals))
  end
end
