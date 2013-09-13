class TweetWorker
  include Sidekiq::Worker

  def perform(user_id, tweet)
    user = User.find(user_id)
    create_tweet = user.tweets.create!(tweet: tweet)
    
    client = Twitter::Client.new(oauth_token: user.oauth_token, 
      oauth_token_secret: user.oauth_secret)
    client.update(tweet)
  end
end
