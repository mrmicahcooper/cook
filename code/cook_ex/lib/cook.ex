defmodule Cook do
  @flags [
    strict: [
      input: :string,
      output_dir: :string,
      pretty: :boolean
    ],
    aliases: [
      i: :input,
      o: :output_dir,
      p: :pretty
    ]
  ]

  def main(args) do
    options = options(args)

    input_files = options.input
                  |> Path.wildcard()
                  |> Enum.map(&Path.expand/1)

    output_dir = Path.expand(options.output_dir)

    Enum.each(input_files, &save_json(&1, output_dir))
    Enum.each(input_files, &save_json(&1, output_dir, true))
  end

  def save_json(path, output_dir, pretty \\false) do
    name = path |> Path.rootname() |> Path.basename()
    content = File.read!(path) |> Decoder.decode!() |> Jason.encode!(pretty: pretty)
    extension = if pretty, do: ".json", else: ".min.json"

    json_path = Path.join(output_dir, name<>extension)

    File.write!(json_path, content)
    IO.puts("====>   "<>json_path)
  end

  defp options(args) do
    options = OptionParser.parse(args, @flags)
             |> elem(0)
             |> Enum.into(%{})

    Map.merge(defaults(), options)
  end

  defp defaults() do
    %{
      input: Path.expand("*.txt"),
      output_dir: Path.expand("."),
      pretty: false
    }
  end


end
