module Action
  extend ActiveSupport::Concern

  def index
    @tweets = current_user.tweet

    @tweets.each do |tweets|
      next unless params[:select] == tweets.name
      @a = tweets.key
      @b = tweets.secret
      @c = tweets.token
      @d = tweets.token_secret
    end

    config = {
        consumer_key: @a,
        consumer_secret: @b,
        access_token: @c,
        access_token_secret: @d
    }

    if (params[:select_action] == 'follow') || (params[:select_action] == 'unfollow')
      client = Twitter::REST::Client.new config

      def get_follower_ids(client, user_id)
        follower_ids = []
        next_cursor = -1
        while next_cursor != 0
          cursor = client.follower_ids(user_id, cursor: next_cursor)
          follower_ids.concat cursor.attrs[:ids]
          next_cursor = cursor.send(:next_cursor)
        end
        follower_ids
      end

      def get_friend_ids(client, user_id)
        friend_ids = []
        next_cursor = -1
        begin
          while next_cursor != 0
            cursor = client.friend_ids(user_id, cursor: next_cursor)
            friend_ids.concat cursor.attrs[:ids]
            next_cursor = cursor.send(:next_cursor)
          end
        rescue Twitter::Error::Unauthorized
          []
        end
        friend_ids
      end

      def get_followers_info(client)
        followers = []
        get_follower_ids(client, client.user.id).each_slice(100) do |ids|
          followers.concat client.users(ids)
        end
        followers
      end

      def get_friends_info(client)
        friends = []
        get_friend_ids(client, client.user.id).each_slice(100) do |ids|
          friends.concat client.users(ids)
        end
        friends
      end

      begin
        @followers = []
        followers = get_followers_info(client)
        followers.each_with_index do |user, _index|
          @followers << user.id
          puts "adding follower to an array: #{user.id}"
        end
      rescue Twitter::Error::TooManyRequests
        []
        puts "rescue Twitter::Error #{Time.now}"
        sleep 905
        retry
      end
      begin
        @friends = []
        friends = get_friends_info(client)
        friends.each_with_index do |user, _index|
          @friends << user.id
          puts "adding friend to an array: #{user.id}"
        end
      rescue Twitter::Error::TooManyRequests
        []
        puts "rescue Twitter::Error #{Time.now}"
        sleep 905
        retry
      end
      if params[:select_action] == 'follow'
        @follow = @followers - @friends
        begin
          @follow.take(100).reverse_each do |line|
            client.follow(line)
            @follow.delete(line)
            puts "follow: #{line} #{Time.now}"
            sleep rand(1..5)
          end
        rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
          []
          puts "rescue Twitter::Error #{Time.now}"
          sleep 905
          retry
        end
      elsif params[:select_action] == 'unfollow'
        @unfollow = @friends - @followers
        begin
          @unfollow.take(1000).reverse_each do |line|
            client.unfollow(line)
            @unfollow.delete(line)
            puts "unfollow: #{line} #{Time.now}"
            sleep rand(1..5)
          end
        rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
          []
          puts "rescue Twitter::Error #{Time.now}"
          sleep 905
          retry
        end
      end
    end
    if params[:select_action] == 'retweet'
      $i = 0
      $num = 15
      $i1 = 0
      while $i + $i1 <= $num
        begin
          rClient = Twitter::REST::Client.new config
          sClient = Twitter::Streaming::Client.new(config)
          topics = params['tag'].split(/,/)
          sClient.filter(track: topics.join(',')) do |tweet|
            if tweet.is_a?(Twitter::Tweet)
              flash[:success] ||= []
              flash[:success] << tweet.text
              # puts tweet.text
              rClient.retweet tweet
              $i += 1
              sleep rand(1..15)
              break if $i1 == 15
            end
          end
        rescue StandardError
          # puts 'error occurred, waiting for 5 seconds'
          flash[:notice] ||= []
          flash[:notice] << 'error occurred, waiting for 5 seconds'
          $i1 += 1
          sleep 5
          break if $i1 == 15
        end
      end
    else
      flash.now[:error] = 'Error'
    end

    if params[:select_action] == 'post'
      client = Twitter::REST::Client.new config
      @array = params[:tag].split(/[\r\n]+/)
      @array.each do |i|
        client.update(i)
        sleep rand(1..10)
      end
      flash.now[:success] = 'Tweets published!'
    else
      flash.now[:error] = 'Error. Try again.'
    end
  end
end
