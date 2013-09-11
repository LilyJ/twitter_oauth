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
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  
  # session[:user] = @user
  @username = @access_token.params[:screen_name]
  @user = User.create(username: @username, oauth_token: @access_token.token, oauth_secret: @access_token.secret)
  session[:user_id] = @user.id
  session.delete(:request_token)


  # at this point in the code is where you'll need to create your user account and store the access token

  erb :index
  
end

post '/auth/post' do

  tweet = params[:tweet]
  # p params
  @user = User.find(session[:user_id])
  # p @user
  client = Twitter::Client.new(oauth_token: @user.oauth_token, oauth_token_secret: @user.oauth_secret)
  client.update(tweet)
  content_type :json
  {tweet: tweet}.to_json
end