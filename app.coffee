getUser = (username, callback) ->
  url = "https://api.github.com/users/#{username}?callback=?"
  $.getJSON(url, (data)-> 
    callback(data.data)
  )


$(document).ready ->
  $("#user-search").keyup((event)->
    if event.keyCode == 13
      $(".container").empty()
      username = $(event.target).val()
      getUser(username, (data)->
        h1 = $("<h1>").text(data.name)
        img = $("<img>").attr("src", data.avatar_url)
        $(".container").append(h1).append(img)
      ) 
  )



