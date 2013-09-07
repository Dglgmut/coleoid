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

  def macro_abstract_time_now do
    DateTime.format({{2013,12,12},{00,00,00}} , "Ymd")
  end

  def date_for do
    fn (time) ->
       fn (form) ->
         DateTime.format time, form
       end
    end
  end

  def set_redis do
    {_, estringona} = JSON.encode(['1': [images: "image_legal",
                                         name: "Imarestaurant",
                                         cuisine: "pamonha",
                                         neighbourhood: "goaiana",
                                         lat: "69",
                                         long: "69",
                                         ranking: 5.0,
                                         city: "goiania",
                                         chairs: 5],
                                   '2': [images: "imagem mais legal",
                                         name: "SOU OUTRO RESSTAURANTE",
                                         cuisine: "abacate",
                                         neighbourhood: "brasilandia mano!",
                                         lat: "51",
                                         long: "51",
                                         ranking: 2.2,
                                         city: "barueiri",
                                         chairs: 2] ])
    start |> query ["SET", macro_abstract_time_now, estringona]
  end

  def get_redis do 
    {_, string} = JSON.decode (start |> query ["GET",  macro_abstract_time_now])
    string
  end

  get "/" do
    #currying for the great good
    date_formatted_as = date_for.({{2013,9,7},{12,0,0}})

    conn.put_private :result_object, [ redis_data: get_redis ]
  end

  get "/time_ago" do
    set_redis
    conn.put_private :result_object, get_redis
  end
end
