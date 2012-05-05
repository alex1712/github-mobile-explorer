$(document).ready -> 
  $.getJSON({
    url: "https://api.github.com/users/lenniboy?callback=?"
    success: (data) -> 
      alert(data)
  })
