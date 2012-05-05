$(document).ready -> 
  url = "https://api.github.com/users/#{currentUser}/repos?callback=?"
  console.log url
  $.getJSON(url, (data)-> 
    data = data.data
    source   = $("#user-template").html();
    template = Handlebars.compile(source);
    template = template({repos: data.reverse()});
    
    $("#container").append(template)
  )
