Handlebars.registerHelper('created_at', () -> 
  return new Date(this.created_at).toDateString()
)

GH = 

  buildUserView: () ->
    username = GH.getParameter "username"
    $("#user .container").empty()
    GH.getUserData(username, (data)->
      source = $("#user-template").html();
      template = Handlebars.compile(source);
      $("#user .container").append(template(data))
      $("#user input[type=button]").button().click(()->
        $.mobile.changePage("#repos?username=#{username}")
      )
    )

  getParameter: (paramName) ->
    searchString = window.location.hash.substring(window.location.hash.indexOf("?") + 1)
    params = searchString.split "&"
    result = null
    $.each(params, () ->
      val = this.split("=");
      if val[0] == paramName
        result = unescape(val[1])
        return null
    )
    return result

  getUserData: (username, callback) ->
    url = "https://api.github.com/users/#{username}?callback=?"
    $.getJSON(url, (data)-> 
      callback(data.data)
    )
$(document).ready ->
  userSearch = $("#user-search")
  userSearch.keyup((event)->
    if event.keyCode == 13
      username = $(event.target).val()
      $.mobile.changePage("#user?username=#{username}")
  )
  $("#search-button").click(()->
    username = userSearch.val();
    $.mobile.changePage("#user?username=#{username}")
  )
  $("#user").bind("pagechange", GH.buildUserView)
  
   
  
$(document).delegate("#repos", "pagechange", () ->
  username = GH.getParameter "username"
  url = "https://api.github.com/users/#{username}/repos?callback=?"
  $.getJSON(url, (data)-> 
    data = data.data
    source   = $("#repos-template").html();
    template = Handlebars.compile(source);
    template = template({repos: data.reverse()});
    
    $("#repos .container").append(template)
    $('#repos #repoList').listview();
  )
)
$(document).delegate("#user", "pageinit", GH.buildUserView)
