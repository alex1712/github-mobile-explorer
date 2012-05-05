GH = 
  user: null
  getUserData : (username, callback) ->
    url = "https://api.github.com/users/#{username}?callback=?"
    $.getJSON(url, (data)-> 
      callback(data.data)
    )
  goToUser : (username)->
    $(".container").empty()
    GH.getUserData(username, (data)->
      source = $("#user-template").html();
      template = Handlebars.compile(source);
      $(".container").append(template(data))
      GH.user = username
      $("#page input[type=button]").button()
      $.mobile.changePage("#user")
    ) 


$(document).ready ->
  userSearch = $("#user-search")
  userSearch.keyup((event)->
    if event.keyCode == 13
      username = $(event.target).val()
      GH.goToUser username
  )
  $("#search-button").click(()->
    username = userSearch.val();
    GH.goToUser username
  )






