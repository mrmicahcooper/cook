defmodule Parser.Helpers do
  import NimbleParsec

  def title do
    ignore(string("!"))
    |> label("recipe to start with a \"!\"")
    |> ignore(repeat(string(" ")))
    |> repeat(utf8_char([{:not, ?\n}]))
    |> tag(:title)
  end

  def part do
    ignore(utf8_string([?\n], min: 1))
    |> optional(label())
    |> tag(:label)
    |> concat(instruction())
    |> wrap()
  end


  def action do
    utf8_char([{:not, ?\s}, {:not, ?\n}])
    |> repeat(utf8_char([{:not, ?\n}, {:not, ?\r}]))
    |> ignore(string("\n"))
    |> tag(:action)
    |> wrap()
  end

  def amount do
    utf8_char([?0..?9,?/,?.,?\s])
    |> repeat()
    |> ignore(string("|"))
    |> tag(:amount)
  end

  def unit do
    utf8_char([{:not, ?|}])
    |> repeat()
    |> ignore(string("|"))
    |> tag(:unit)
  end

  def item do
    utf8_char([{:not, ?\n}, {:not, ?[}])
    |> repeat()
    |> tag(:item)
  end

  def modifier do
    ignore(string("["))
    |> repeat(utf8_char([{:not, ?]}]))
    |> ignore(string("]"))
    |> tag(:modifier)
  end

  def ingredient do
    ignore(utf8_string([?\s], min: 1))
    |> concat(amount())
    |> concat(unit())
    |> concat(item())
    |> concat(optional(modifier()))
    |> ignore(utf8_char([?\n]))
    |> tag(:ingredient)
    |> wrap()
  end

  def label do
    string("#")
    |> ignore(repeat(string(" ")))
    |> repeat(utf8_char([{:not, ?\n}, {:not, ?\r}]))
    |> ignore(utf8_char([?\n]))
  end

  def instruction do
    repeat(
      choice([
        action(),
        ingredient()
      ])
    )
    |> tag(:instructions)
  end

  def parts do
    repeat(part())
    |> tag(:parts)
  end

  def recipe do
    title() |> concat(parts())
  end

  def not_double_line_break("\n\n"<>_binary, context, _, _), do: {:halt, context}
  def not_double_line_break("\r\r"<>_binary, context, _, _), do: {:halt, context}
  def not_double_line_break(_, context, _, _), do: {:cont, context}

end
