defmodule ParserTest do
  use ExUnit.Case

  import Access, only: [at: 1]

  test "decode!/1" do
    data = "test/fixtures/pesto.txt"
           |> File.read!()
           |> Decoder.decode!()

    assert data.title == "pesto sauce"
    assert Enum.count(data.parts) == 2
    assert data |> get_in([:parts, at(0), :instructions, at(0), :content]) == "pulse in food processor until roughly chopped"

  end
end
