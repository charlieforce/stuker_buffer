class Post < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :scheduled_at
	validates_length_of :content, maximum: 140, message: "less than 140 please"
	validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now
	after_create :schedule

	# Photo
	has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  	validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
  	
  	# Video  	
  	has_attached_file :video, styles: { medium: "300x300>", thumb: "100x100>" }
  	validates_attachment_content_type :video, content_type: /\Avideo\/.*\z/

  	# has_attached_file :video, styles: {
   #  	medium: {geometry: "640x480", format:'mp4'},
   #  	thumb: {geometry: "100x100#", format:'jpg', time: 10}
   #  }, processors: [:transcoder]
  	# validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/
  	# validates_attachment :video, size: {less_than: 500.megabytes}

	def schedule
		begin
			ScheduleJob.set(wait_until: scheduled_at).perform_later(self)
			self.update_attributes(state: "scheduled")
		rescue Exception => e
			self.update_attributes(state: "scheduling error", error: e.message)
		end
	end

	def display
		begin
			unless state == "canceled"
				if facebook == true
					to_facebook
				end
				if twitter == true
					to_twitter
				end
			end
			self.update_attributes(state: "posted")
		rescue Exception => e
			self.update_attributes(state: "posting error", error: e.message)
		end
	end

	def to_twitter
		client = Twitter::REST::Client.new do |config|
			config.access_token = self.user.twitter.oauth_token
			config.access_token_secret = self.user.twitter.secret
			config.consumer_key = 'uPeNCwSluigzuA39sF3NM9gfD' #ENV['TWITTER_KEY']
			config.consumer_secret = 'E3vS7fUCz6fEV3oQcEprVoeRMrlLwg5CF5mLYFY5UEGxMVswSA' #ENV['TWITTER_SECRET']
		end
		client.update(self.content)
	end

	def to_facebook
		graph = Koala::Facebook::API.new(self.user.facebook.oauth_token)
		graph.put_connections("me", "feed", message: self.content)
	end
end
