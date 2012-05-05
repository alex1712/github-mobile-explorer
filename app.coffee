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
        source = $("#user-template").html();
        template = Handlebars.compile(source);
        $(".container").append(template(data))
      ) 
  )



