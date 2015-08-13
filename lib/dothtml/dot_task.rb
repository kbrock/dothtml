require 'rake'
require 'rake/tasklib'
require_relative 'dot_helper'

module Dothtml
  class DotTask < Rake::TaskLib
    attr_accessor :template
    attr_accessor :style
    attr_accessor :behavior
    attr_accessor :cdn
    attr_accessor :d3js

    attr_accessor :dot_folder
    attr_accessor :html_folder

    def initialize(name = :dot)
      templates = File.expand_path(File.join(File.dirname(__FILE__), "..", "..","templates"))
      @name     = name
      @style    = File.join(templates, 'style.css')
      @behavior = File.join(templates, 'behavior.js')
      @template = File.join(templates, 'index.html.erb')
      self.cdn  = true
      yield self if block_given?
      define
    end

    def cdn=(val)
      @d3js = case val
              when true then "//cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js"
              when false then "d3.v3.js"
              else val
              end
    end

    def define
      desc "convert dot file into an html file"
      task :dot_html, [:src, :target] do |t, params|
        source = params[:src]
        target = params[:target]

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

      desc "convert dot file into an svg file"
      task :dot_svg, [:src, :target] do |t, params|
        source = params[:src]
        target = params[:target]

        puts "#{source} -> #{target}"

        doc = DotHelper.from_dotfile(source)#.embed_images
        File.write(target, doc.to_xml)
      end

      rule '.html' => [".dot", style, template, behavior] do |t|
        Rake::Task["dot_html"].execute(:target => t.name, :src => t.source)
        Rake::Task["refresh_browser"].invoke
      end

      rule '.svg' => [".dot"] do |t|
        Rake::Task["dot_svg"].execute(:target => t.name, :src => t.source)
      end

      # TODO: find proper tab, offer non chrome options
      # use guard / live upate?
      desc "use applescript to refresh front most window in chrome"
      task :refresh_browser do
        puts "refreshing browser"
        `osascript -e 'tell application "Google Chrome" to tell the active tab of its first window to reload'` 
      end
    end
  end
end
