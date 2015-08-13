require 'minitest_helper'

class TestDotHelper < Minitest::Test
  def dot_helper(contents = nil)
    DotHelper.new contents
  end

  private

  def dom(contents, at=nil)
    node = Nokogiri::XML.parse(contents)
    at ? node.at(at) : node
  end
end
