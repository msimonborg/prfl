# To execute, run `$ elixir scripts/reverse_boost_filenames.exs` from the
# `prfl` parent directory

# This script reverses the order of the boost filename format
# e.g. "20261015052053076567_7835.json" becomes "7835_20261015052053076567.json"
# and vice versa

# TODO: Add TaskSupervisor for async processing as file list grows

data_dir = "../../boost_data/raw"

file_list = File.ls!(data_dir)

reverse_names =
  fn filename ->
    [name | ext] = String.split(filename, ".")

    new_name =
      name
      |> String.split("_")
      |> Enum.reverse()
      |> Enum.join("_")

    {filename, Enum.join([new_name | ext], ".")}
  end

rename_files =
  fn {old_name, new_name} ->
    source = "#{data_dir}/#{old_name}"
    destination = "#{data_dir}/#{new_name}"
    File.rename!(source, destination)
  end

children = [
  {Task.Supervisor, name: Prfl.ScriptSupervisor}
]

Supervisor.start_link(children, strategy: :one_for_one)

stream1 =
  Task.Supervisor.async_stream(
    Prfl.ScriptSupervisor,
    file_list,
    reverse_names
  )

mv_list = Enum.map(stream1, fn {:ok, result} -> result end)

stream2 =
  Task.Supervisor.async_stream(
    Prfl.ScriptSupervisor,
    mv_list,
    rename_files
  )

Stream.run(stream2)
