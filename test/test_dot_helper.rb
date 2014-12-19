require 'minitest_helper'

class TestDotHelper < MiniTest::Unit::TestCase
  def dot_helper(contents = nil)
    DotHelper.new contents
  end

  def test_extract_id_class_with_id
    assert_equal ["x1"], dot_helper.extract_id_class("x1")
  end

  def test_extract_id_class_with_class_eq
    assert_equal ["", "x1"], dot_helper.extract_id_class("class=x1")
  end

  def test_extract_id_class_with_id_class_eq
    assert_equal ["x1", "c1"], dot_helper.extract_id_class("x1 class=c1")
  end

  def test_extract_id_class_with_id_class_eq_quote
    assert_equal ["x1", "c1"], dot_helper.extract_id_class("x1 class='c1'")
  end

  def test_extract_id_class_with_id_class_eq_dbl_quote
    assert_equal ["x1", "c1"], dot_helper.extract_id_class('x1 class="c1"')
  end

  def test_merge_id_class_with_id_class_eq_and_class
    assert_equal ["x1", "c0 c1"], dot_helper.merge_id_class('x1 class="c1"', "c0")
  end

  def test_merge_id_class_with_id_multi_class_eq_and_class
    assert_equal ["x1", "c0 c1 c2"], dot_helper.merge_id_class('x1 class="c1 c2"', "c0")
  end

  def test_fix_node_id_with_id_class_eq_and_class
    node = dot_helper.fix_node_id(dom(%{<x><div id="x1 class=c1"></div></x>}, "div"))
    assert_equal "x1", node["id"]
    assert_equal "c1", node["class"]
  end

  def test_fix_ids
    node = dot_helper(%{<x><div id="x1 class=c1" class="c0"></div></x>}).fix_ids.dom
    assert_equal "x1", node.at("div")["id"]
    assert_equal "c0 c1", node.at("div")["class"]
  end

  private

  def dom(contents, at=nil)
    node = Nokogiri::XML.parse(contents)
    at ? node.at(at) : node
  end
end
