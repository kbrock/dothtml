require 'dothtml/dot_helper'

module Dothtml
  class DotTask
    attr_accessor :template
    attr_accessor :style
    attr_accessor :behavior
    attr_accessor :cdn
    attr_accessor :d3js

    def initialize
      @style    = File.join(TEMPLATES_DIR, 'style.css')
      @behavior = File.join(TEMPLATES_DIR, 'behavior.js')
      @template = File.join(TEMPLATES_DIR, 'index.html.erb')
      self.cdn  = true
      yield self if block_given?
    end

    def cdn=(val)
      @cdn = val
      @d3js = case val
              when true  then "//cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"
              when false then "d3.v3.js"
              else val
              end
    end

    def build(*files)
      files.flatten.each do |f|
        dot_to_svg(f)
        dot_to_html(f)
      end
    end

    private

    def dot_to_html(source)
      target = source.sub(/.dot$/, ".html")
      puts "#{source} -> #{target}"

      doc = DotHelper.from_dotfile(source)#.embed_images
      doc.write target, @template,
                title:    doc.extractTitle,
                body:     doc.to_xml,
                choices:  doc.extractChoices,
                descriptions: doc.descriptions?,
                style:    File.read(style),
                behavior: File.read(behavior),
                d3js:     d3js
    end

    def dot_to_svg(source)
      target = source.sub(/.dot$/, ".svg")
      puts "#{source} -> #{target}"

      doc = DotHelper.from_dotfile(source)#.embed_images
      File.write(target, doc.to_xml)
    end
  end
end
