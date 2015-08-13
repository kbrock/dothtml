require 'html/pipeline'
require 'dothtml/dot_helper'

module HTML
  class Pipeline
    class DotFilter < Filter
      LANGUAGES=%w(dot neato).freeze

      def call
        doc.search("pre").each do |node|
          code = node.children.first
          lang = must_str(code && code["class"])
          next unless LANGUAGES.include?(lang)
          doc = DotHelper.from_dot(code.inner_text, lang)
          doc.remove_comments

          node.replace(doc.node).first
        end

        doc
      end

      def must_str(text)
        text && text.to_s
      end
    end
  end
end
