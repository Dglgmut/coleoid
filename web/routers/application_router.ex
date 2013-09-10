defmodule ApplicationRouter do
  use Dynamo.Router
  use Exredis

  filter JSON.Dynamo.Filter

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  # It is common to break your Dynamo into many
  # routers, forwarding the requests between them:
  # forward "/posts", to: PostsRouter

  #ex for datetime: "201309212230"
  def get_redis(datetime) do
    (start('127.0.0.1', 6379, 2) |> query ["SMEMBERS", datetime])
  end

  def decode(list, elements ) do
    {_, decoded} = JSON.decode(list)
    Enum.map(elements, fn(x) -> {x, decoded[x]} end )
  end

  get "/" do
    redis_data = get_redis(conn.params[:datetime])
    filtered_data = Enum.map(redis_data, fn(x) -> decode(x, ["name", "id"]) end)
    conn.put_private :result_object, filtered_data #get_redis(conn.params[:datetime])
  end
end
