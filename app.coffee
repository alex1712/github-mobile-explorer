$(document).ready -> 
  
  url = "https://api.github.com/users/lenniboy?callback=?"
  
  $.getJSON(url, (data)-> 
    data = data.data
    h1 = $("<h1>").text(data.name)
    img = $("<img>").attr("src", data.avatar_url)
    
    $(".container").append(h1).append(img)

    console.log(data)
    console.log(status)
  )
