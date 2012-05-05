(function() {
  $(document).ready(function() {
    var url;
    url = "https://api.github.com/users/" + currentUser + "/repos?callback=?";
    console.log(url);
    return $.getJSON(url, function(data) {
      var source, template;
      data = data.data;
      source = $("#user-template").html();
      template = Handlebars.compile(source);
      template = template({
        repos: data.reverse()
      });
      return $("#container").append(template);
    });
  });
}).call(this);
