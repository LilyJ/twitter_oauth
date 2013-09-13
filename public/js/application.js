$(document).ready(function() {
  $('form').submit(function(event){
    event.preventDefault();
    var input = $('#input').val();
    $.ajax({
      url: this.action,
      type: this.method,
      data: {tweet: input}
    }).done(function(response){
      var gettingStatus = false
      var tweet = response.tweet
  
      var intervalId = setInterval(function(){
        console.log("interval")
        if (!gettingStatus){
          gettingStatus = true
          $.ajax({
            url: '/status/' + response.jid,
            type: "get"
          }).done(function(response){
            gettingStatus = false
            if (response.done){
              $('#tweets_list').append('<li>' + tweet + '</li>')
              clearInterval(intervalId);
            }
            else{
              console.log("processing...")
            }
          })
        }
      }, 10);
    }); 
  })
});


// lilyyyyyy....fix this then deploy to heroku using proc file
// then do app ahoy -> if it's not too easy

// refactor tip: var name need to tell what it suppose to do
// if it fat then it's bad -> extract!!  *fat= too much indentation on the front



