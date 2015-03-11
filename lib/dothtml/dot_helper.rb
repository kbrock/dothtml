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

  def extract_id_class(old_id)
    if old_id =~ /(.*?) ?class=["']?(.*?)['"]?$/
      [$1, $2]
    else
      [old_id]
    end
  end

  def merge_id_class(old_id, old_class)
    new_id, new_class = extract_id_class(old_id)
    [new_id, [old_class, new_class].compact.join(" ")]
  end

  # some nodes are of the form <div id="x1 class='other'" class="c1">
  # assume (class= is present)
  def fix_node_id(node)
    new_id, new_class = merge_id_class(node["id"], node["class"])
    node["id"] = new_id
    node["class"] = new_class
    node
  end

  def embed_images
    dom.at("svg").children.before(images)
    self
  end

  def fix_ids
    dom.xpath("//*[contains(@id,'class=')]").each { |n| fix_node_id(n) }
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
