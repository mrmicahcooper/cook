defmodule CookTest do
  use ExUnit.Case
  doctest Cook

  test "parse/1" do
    recipe = File.read!("../../pizza.txt")
    data = Cook.parse(recipe)
    assert data.title == "pizza"
    assert List.first(data.parts).label == "yeast"
  end
end
