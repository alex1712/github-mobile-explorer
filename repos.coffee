$(document).ready -> 
  url = "https://api.github.com/users/lenniboy/repos?callback=?"
  console.log url
  $.getJSON(url, (data)-> 
    data = data.data
    source   = $("#user-template").html();
    template = Handlebars.compile(source);
    Handlebars.registerHelper('created_at', () -> 
      return new Date(this.created_at).toDateString()
    )
    template = template({repos: data.reverse()});
    
    $("#container").append(template)
    $('#repoList').listview();
  )
