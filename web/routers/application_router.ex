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

  def time_now do
    DateTime.format DateTime.now, "h:i:s"
  end

  def date_for do
    fn (time) ->
       fn (form) ->
         DateTime.format time, form
       end
    end
  end

  def set_redis, do: start |> query ["SET", "TimeAgo", time_now]
  def get_redis, do: start |> query ["GET", "TimeAgo"]

  get "/" do
    #currying for the great good
    date_formatted_as = date_for.({{2013,9,7},{12,0,0}})

    conn.put_private :result_object, [ time_now: time_now, date_now: date_formatted_as.("Y"), redis_data: get_redis ]
  end

  get "/time_ago" do
    set_redis
    conn.put_private :result_object, ["setted redis to #{get_redis}"]
  end
end
