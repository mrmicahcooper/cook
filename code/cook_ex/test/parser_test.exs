defmodule ParserTest do
  use ExUnit.Case
  import NimbleParsec

  test "title" do
    json = "test/fixtures/apple-cider.txt"
           |> File.read!()
           |> Parser.decode()

    IO.inspect(json)

    assert json == %{}
  end
end
