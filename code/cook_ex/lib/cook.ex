defmodule Cook do
  import String, only: [trim: 1]

  def parse(recipe_string) do
    recipe = %{
      title: "",
      parts: []
    }

    recipe_string
    |> String.split("\n")
    |> parse(recipe)
  end

  def parse(["!"<>title|tail], recipe) do
    parse(tail, %{recipe | title: trim(title)})
  end

  def parse([""|tail], recipe), do: parse(tail, recipe)

  def parse(["#"<>label|tail], recipe) do
    part = %{label: label, instructions: []}
    recipe = put_in(recipe, [:parts], fn(a,b,c) ->
      [part|b]
    end.())
  end

  def parse(_, state), do: state

end
