class User < ActiveRecord::Base
  has_many :tweets

  def tweet(tweet)
    TweetWorker.perform_async(id, tweet)
  end
end
