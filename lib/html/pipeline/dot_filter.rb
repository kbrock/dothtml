require 'html/pipeline'
require 'dothtml/dot_helper'

module HTML
  class Pipeline
    class DotFilter < Filter
      LANGUAGES=%w(dot).freeze

      def call
        doc.search("pre").each do |node|
          code = node.children.first
          lang = must_str(code && code["class"])
          next unless LANGUAGES.include?(lang)
          text = code.inner_text

          dom = DotHelper.from_dot(text, lang).fix_ids.remove_comments.node

          node.replace(dom).first
        end

        doc
      end

      def must_str(text)
        text && text.to_s
      end
    end
  end
end
