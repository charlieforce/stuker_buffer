class Post < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :scheduled_at, :if => lambda { |o| o.sending_mode != "Now" }
	validates_length_of :content, maximum: 140, message: "less than 140 please"
	validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now, :if => lambda { |o| o.sending_mode != "Now" }
	attr_accessor :weekdays

	enum sending_mode: [:Now, :Once, :Recurring]

	# file attachment
	has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	validates_attachment_content_type :attachment, :content_type => ["video/mp4", "image/jpg", "image/jpeg", "image/png", "image/gif"]  
  	
	def schedule(weekdays)
		begin
			if(self.sending_mode == "Now")
				ScheduleJob.set(wait_until: Time.current).perform_now(self)
				self.update_attributes(state: "scheduled")
			elsif (self.sending_mode == "Recurring")
				ScheduleJob.set(wait_until: self.scheduled_at).perform_later(self)
				start_date = self.scheduled_at.to_date
				end_date = self.end_time.to_date
				days = weekdays.map{|a| a.to_i}
				result = (start_date..end_date).to_a.select {|k| days.include?(k.wday)}

				result.each do |date|
					ScheduleJob.set(wait_until: date.to_time).perform_later(self)
				end
				self.update_attributes(state: "scheduled")
			else	
				ScheduleJob.set(wait_until: self.scheduled_at).perform_later(self)
				self.update_attributes(state: "scheduled")
			end
			
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
				if google_oauth2 == true
					to_google_oauth2
				end
				if instagram == true
					to_instagram
				end
				if pinterest == true
					to_pinterest
				end
				if tumblr == true
					to_tumblr
				end				
			end
			if self.sending_mode != "Recurring" && self.end_time < Time.current
				self.update_attributes(state: "posted")
			end
		rescue Exception => e			
			self.update_attributes(state: "posting error", error: e.message)
		end
	end

	def to_twitter	
		if Rails.env.production?
			# Production
			client = Twitter::REST::Client.new do |config|
				config.access_token = self.user.twitter.oauth_token
				config.access_token_secret = self.user.twitter.secret				
				config.consumer_key =  ENV['TWITTER_KEY']
				config.consumer_secret =  ENV['TWITTER_SECRET']
			end
			file_url = "/public#{self.attachment.url(:original, timestamp: false)}"
			if File.exist?(file_url)
				client.update_with_media(self.content, File.open(file_url))
			else
				client.update(self.content)
			end
		else 
			# Development
			client = Twitter::REST::Client.new do |config|
				config.access_token = self.user.twitter.oauth_token
				config.access_token_secret = self.user.twitter.secret											
				config.consumer_key 	=  'uPeNCwSluigzuA39sF3NM9gfD'
				config.consumer_secret 	=  'E3vS7fUCz6fEV3oQcEprVoeRMrlLwg5CF5mLYFY5UEGxMVswSA'
			end
			file_url = "#{Rails.root}/public#{self.attachment.url(:original, timestamp: false)}"
			if File.exist?(file_url)
				client.update_with_media(self.content, File.open(file_url))
			else
				client.update(self.content)
			end
		end
		
	end

	def to_facebook		
		graph = Koala::Facebook::API.new(self.user.facebook.oauth_token)
		graph.put_connections("me", "feed", message: self.content)

		file_url = "#{Rails.root}/public#{self.attachment.url(:original, timestamp: false)}"
		if File.exist?(file_url)
			graph.put_picture(file_url)
		end		
	end

	def to_google_oauth2

	end

	def to_instagram

	end

	def to_pinterest
		client = Pinterest::Client.new(self.user.pinterest.oauth_token)
		logger.debug "====PIN==#{client.inspect}"
		client.create_pin({
		  # board: client.get_boards.id,
		  note: self.content,
		  link: 'https://stucker.herokuapp.com',
		  image_url: self.photo.url
		})
	end

	def to_tumblr
	end
end
