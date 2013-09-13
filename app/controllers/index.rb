enable :sessions

get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  unless session[:user_id]
    @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    
    @username = @access_token.params[:screen_name]
    @user = User.create(username: @username, oauth_token: @access_token.token, oauth_secret: @access_token.secret)
    session[:user_id] = @user.id
    session.delete(:request_token)
  else
    @user = User.find(session[:user_id])
  end


  # at this point in the code is where you'll need to create your user account and store the access token

  erb :index
  
end

post '/auth/post' do
  tweet = params[:tweet]
  @user = User.find(session[:user_id])
  jid = @user.tweet(tweet)
  content_type :json
  {tweet: tweet, jid: jid}.to_json
end

get '/status/:job_id' do
  content_type :json
  {done: job_is_complete(params[:job_id])}.to_json

end

