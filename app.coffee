Handlebars.registerHelper('created_at', () -> 
  return new Date(this.created_at).toDateString()
)

GH = 
  getUserData: (username, callback) ->
    url = "https://api.github.com/users/#{username}?callback=?"
    $.getJSON(url, (data)-> 
      callback(data.data)
    )
  goToUser: (username)->
    $(".container").empty()
    GH.getUserData(username, (data)->
      source = $("#user-template").html();
      template = Handlebars.compile(source);
      $("#user .container").append(template(data))
      $("#user input[type=button]").button().click(()->
        GH.showRepos(username)
      )
      $.mobile.changePage("#user")
    )
  showRepos: (username) ->
    $.mobile.changePage("#repos")
    url = "https://api.github.com/users/#{username}/repos?callback=?"
    $.getJSON(url, (data)-> 
      data = data.data
      source   = $("#repos-template").html();
      template = Handlebars.compile(source);
      template = template({repos: data.reverse()});
      
      $("#repos .container").append(template)
      $('#repos #repoList').listview();
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






