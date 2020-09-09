defmodule Parser.Helpers do
  import NimbleParsec

  def title do
    string("!")
    |> ignore()
    |> string(" ")
    |> optional()
    |> ignore()
    |> repeat(utf8_char([{:not, ?\n}, {:not, ?\r}]))
    |> tag(:title)
  end

  def part do
    string("\n\n")
    |> ignore()
    |> repeat_while(utf8_char([]), :not_double_line_break)
    |> tag(:part)
  end
end
