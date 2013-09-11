$(document).ready(function() {
  $('form').submit(function(event){
    event.preventDefault();
    var input = $('#input').val();
    $.ajax({
      url: this.action,
      type: this.method,
      data: {tweet: input}
    }).done(function(response){
      console.log("done")
      $('#tweets_list').append('<li>' + response.tweet + '</li>')
    });
  })
});



 