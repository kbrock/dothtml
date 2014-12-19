require "tilt"
require 'nokogiri'
require 'set'
require 'open3'

class DotHelper
  def initialize(svg_contents)
    @svg_contents = svg_contents
  end

  def parse_dom(contents)
    Nokogiri::XML.parse(contents)
  end

  def dom
    @dom ||= parse_dom(@svg_contents)
  end

  def extractChoices
  end

  def descriptions?
    #dom.css("")
  end

  def extractTitle
    dom.css("title").first.content()
  end

  # this currently has too many limitations
  # working on making this more friendly
  # assume unique list of filenames
  def images
    embedded_images = Set.new

    defs = dom.create_element("def")
    namespace = defs.namespace

    # assuming the images are the correct size, declare their size
    dom.css("image").each do |img|
      file_name = img.attributes["href"].value
      id = file_name.split(".").first.split("/").last
      if file_name =~ /\.svg$/ && ! embedded_images.include?(file_name)
        src = parse_dom(File.read(file_name)).at("svg")
        g = dom.create_element("g", id: id,
          width: src["width"], height: src["height"])
        defs.add_child(g)
        src.children.each do |child|
          g.add_child(child.clone)
        end
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
    dom.at("svg").children.before(images)
    self
  end

  # uses a fragment to remove extra xml declarations
  def to_xml
    dom.at("svg").to_xml
  end

  def write(file_name, template_name, locals)
    File.write(file_name, Tilt.new(template_name).render(binding, locals))
  end

  def self.from_dotfile(filename)
    new(svg_from_dot(File.read(filename)))
  end

  def self.from_dot(contents)
    new(svg_from_dot(contents))
  end

  def self.svg_from_dot(contents)
    Open3.popen3('dot -Tsvg') do |stdin, stdout, stderr|
      stdout.binmode
      stdin.print contents
      stdin.close

      err = stderr.read
      if !err.nil? && !err.strip.empty?
        raise "Error from graphviz:\n#{err}"
      end

      stdout.read.tap { |str| str.force_encoding 'UTF-8' }
    end
  end
end
