defmodule Cook do
  def parse(string) do
    acc = ~s[{"title":"]
    state = nil
    parse(string, state, acc)
  end

  def parse("!"<>tail, nil, acc) do
    parse(tail, :title, acc)
  end

  def parse("\n"<>tail, :title, acc) do
    parse(tail, nil, acc <> ~s["])
  end

  def parse("\n"<>tail, nil, acc) do
    parse(tail, nil, acc)
  end

  def parse("\n"<>tail, :part, acc) do
    parse(tail, :part, acc <> ~s|","instructions":[|)
  end

  def parse("  "<>tail, state, acc) when state in [:part, :title] do
    parse(tail, state, acc <> head)
  end

  def parse(<<head::binary-1, tail::binary>>, state, acc) when state in [:part, :title] do
    parse(tail, state, acc <> head)
  end

  def parse(<<head::binary-1, tail::binary>>, state, acc) when state in [:part, :title] do
    parse(tail, state, acc <> head)
  end

  def parse("#"<>tail, nil, acc) do
    parse(tail, :part, acc <> ~s[,"parts":[{label":"])
  end

  def parse("", _state, acc) do
    acc <> "}"
  end

  def parse(_, nil , acc) do
    acc
  end

  # def parse(<<head::binary-1, tail::binary>>, :content, acc) do
  #   parse(tail, :content, acc <> head)
  # end

end
