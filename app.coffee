Handlebars.registerHelper('created_at', () -> 
  return new Date(this.created_at).toDateString()
)

GH = 
  #routing functionality
  _routes:[]
  route: (selector, callback)->
    GH._routes.push({selector:selector, callback:callback})
  _dispatch:(callback)->
    params = GH._params()
    callback(params)
  start: ()->
    $.each(GH._routes, (index, route)->
      $(document).delegate(route.selector, "pageinit", ()->
        GH._dispatch route.callback
        $('[type='submit']').button('refresh');
      )
    )
    $(document).ready ->
      $(document).bind("pagechange", (event, options)->
        $.each(GH._routes, ()->
          if options.toPage.is(this.selector)
            $('[type='submit']').button('refresh');
            GH._dispatch this.callback
        )
      )
  _params: () ->
    searchString = window.location.hash.substring(window.location.hash.indexOf("?") + 1)
    params = searchString.split "&"
    result = {}
    $.each(params, () ->
      val = this.split("=");
      key = val[0]
      value = val[1]
      result[key] = value
    )
    return result

  #data access
  getUserData: (username, callback) ->
    url = "https://api.github.com/users/#{username}?callback=?"
    $.getJSON(url, (data)-> 
      callback(data.data)
    )

GH.route("#user", (params)->
  username = params.username 
  $("#user .container").empty()
  GH.getUserData(username, (data)->
    source = $("#user-template").html();
    template = Handlebars.compile(source);
    $("#user .container").html(template(data))
    $("#user input[type=button]").button().click(()->
      $.mobile.changePage("#repos?username=#{username}")
    )
  )
)

GH.route("#repos", (params)->
  username = params.username 
  url = "https://api.github.com/users/#{username}/repos?callback=?"
  $.getJSON(url, (data)-> 
    data = data.data
    source   = $("#repos-template").html();
    template = Handlebars.compile(source);
    template = template({repos: data.reverse()});
    $("#repos .container").html(template)
    $('#repos #repoList').listview();
    $('#repos h1').text("#{username}'s repositories")
    $('#repos #repoList a').click(()->
      repo = this.text
      $.mobile.changePage("#commit?username=#{username}&repo=#{repo}")
      return false
    )
  )
)

GH.route("#commit", (params)->
  username = params.username
  repo = params.repo
  url = "https://api.github.com/repos/#{username}/#{repo}/commits"
  $("#commit .container").empty()
  $.getJSON(url, (data)-> 
    source   = $("#commit-template").html();
    template = Handlebars.compile(source);
    template = template({commits: data.reverse()});
    $("#commit .container").html(template)
    $('#commit #commitList').listview();
    $('#commit h1').text("#{username}'s repositories")
  )
)

GH.start()
$(document).ready ->
  userSearch = $("#user-search")
  userSearch.keyup((event)->
    if event.keyCode == 13
      username = $(event.target).val()
      $.mobile.changePage("#user?username=#{username}")
  )
  $("#search-button").click(()->
    username = this.val();
    $.mobile.changePage("#user?username=#{username}")
  )

window.GH = GH
