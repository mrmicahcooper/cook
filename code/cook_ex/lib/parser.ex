defmodule Parser do
  import NimbleParsec
  import Parser.Helpers

  defparsec :tokenize, recipe()

  def decode!(string) do
    acc = %{
      title: nil,
      parts: []
    }

    string
    |> tokenize()
    |> elem(1)
    |> Enum.reduce(acc, &to_map/2)
  end

  def to_map({:title, title}, acc) do
    Map.put(acc, :title, to_string(title))
  end

  def to_map({:parts, parts}, acc) do
    Map.put(acc, :parts, Enum.map(parts, &part/1))
  end

  def part(part) do
    Enum.reduce(part, %{}, &part/2)
  end

  def part({:label, label}, acc) do
    Map.put(acc, :label, to_string(label))
  end

  def part({:instructions, instructions}, acc) do
    Map.put(acc, :instructions, Enum.map(instructions, &instruction/1))
  end

  def instruction([{:action, value}]) do
    %{
      type: :action,
      content: to_string(value)
    }
  end

  def instruction([{:ingredient, ingredient}]) do
    %{type: :ingredient,
      content: Enum.into(ingredient, %{}, fn({key,value}) ->
        { key, to_string(value) |> String.trim() }
      end)
    }
  end
end
