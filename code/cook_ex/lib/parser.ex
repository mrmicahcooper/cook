defmodule Parser do
  import NimbleParsec

  title =
    ignore(string("!"))
    |> label("recipe to start with a \"!\"")
    |> ignore(repeat(string(" ")))
    |> repeat(utf8_char([{:not, ?\n}]))
    |> tag(:title)

  action =
    utf8_char([{:not, ?\s}, {:not, ?\n}])
    |> repeat(utf8_char([{:not, ?\n}, {:not, ?\r}]))
    |> ignore(string("\n"))
    |> tag(:action)

  amount =
    utf8_char([?0..?9,?/,?.,?\s])
    |> repeat()
    |> ignore(string("|"))
    |> tag(:amount)

  unit =
    utf8_char([{:not, ?|}])
    |> repeat()
    |> ignore(string("|"))
    |> tag(:unit)

  item =
    utf8_char([{:not, ?\n}, {:not, ?[}])
    |> repeat()
    |> tag(:item)

  modifier =
    ignore(string("["))
    |> repeat(utf8_char([{:not, ?]}]))
    |> ignore(string("]"))
    |> tag(:modifier)

  ingredient =
    ignore(utf8_string([?\s], min: 1))
    |> concat(amount)
    |> concat(unit)
    |> concat(item)
    |> concat(optional(modifier))
    |> ignore(utf8_char([?\n]))
    |> tag(:ingredient)

  label =
    string("#")
    |> ignore(repeat(string(" ")))
    |> repeat(utf8_char([{:not, ?\n}, {:not, ?\r}]))
    |> ignore(utf8_char([?\n]))
    |> tag(:label)

  instruction =
    [action, ingredient]
    |> choice()
    |> repeat()
    |> tag(:instructions)

  part =
    ignore(utf8_string([?\n], min: 1))
    |> optional(label)
    |> concat(instruction)
    |> tag(:part)

  recipe =
    title
    |> concat(
      repeat(part)
    )

  def not_double_line_break("\n\n"<>_binary, context, _, _), do: {:halt, context}
  def not_double_line_break("\r\r"<>_binary, context, _, _), do: {:halt, context}
  def not_double_line_break(_, context, _, _), do: {:cont, context}

  def not_line_break("\n"<>_binary, context, _, _), do: {:halt, context}
  def not_line_break("\r"<>_binary, context, _, _), do: {:halt, context}
  def not_line_break(_, context, _, _), do: {:cont, context}

  defparsec :decode, recipe

end
