fetch_list =
  "fetch_list.json"
  |> File.read!()
  |> JSON.decode!()

cookie = File.read!("cookie")

data_dir =
  if System.get_env("PRFL_ENV") == "prod" do
    System.get_env("PRFL_BOOST_PATH")
  else
    Path.join(__DIR__, "../data/boost_data/raw")
  end

if !File.exists?(data_dir) do
  File.mkdir_p(data_dir)
end

fun = fn profile ->
  request =
    """
    curl -s 'https://boost.stronghold.coffee/rstry/profile/detail/get.sq?prodCd=10006&prflMCd=#{profile["id"]}&rc=w0' \
    -X 'GET' \
    -H 'Accept: application/json, text/javascript, */*; q=0.01' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Accept-Language: en-US,en;q=0.9' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15' \
    -H 'Referer: https://boost.stronghold.coffee/rstry/profile/detail.sq?rc=w0&pCd=10006&cd=20261014051737838289&lang=en' \
    -H 'Connection: keep-alive' \
    -H 'Cookie: lang=en; boost=#{cookie}' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -H 'Priority: u=3, i'
    """

  {response, 0} = System.shell(request, use_stdio: true)

  filename = profile["filename"]
  File.write!("#{data_dir}/#{filename}", response)
  # Return the filename
  filename
end

children = [
  {Task.Supervisor, name: Prfl.TaskSupervisor}
]

Supervisor.start_link(children, strategy: :one_for_one)

stream =
  Task.Supervisor.async_stream(
    Prfl.TaskSupervisor,
    fetch_list,
    fun,
    timeout: :infinity
  )

total_count = Enum.count(fetch_list)

Enum.with_index(stream, fn {:ok, filename}, index ->
  num = index + 1

  IO.puts(
    "Saved #{num} of #{total_count} profiles as #{filename}, #{total_count - num} remaining"
  )
end)
