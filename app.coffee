$(document).ready -> 
  
  url = "https://api.github.com/users/lenniboy?callback=?"
  
  $.getJSON(url, (data)-> 
      console.log(data)
      console.log(status)
  )
