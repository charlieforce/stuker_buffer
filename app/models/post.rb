class Post < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :scheduled_at
	validates_length_of :content, maximum: 140, message: "less than 140 please"
	validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now
	after_create :schedule

	# file attachment
	has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	validates_attachment_content_type :attachment, :content_type => ["video/mp4", "image/jpg", "image/jpeg", "image/png", "image/gif"]


  	# has_attached_file :attachment,
   #      styles: lambda { |a| a.instance.is_image? ? {:small => "x200>", :medium => "x300>", :large => "x400>"}  : {:thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10}, :medium => { :geometry => "300x300#", :format => 'jpg', :time => 10}}},
   #      :processors => lambda { |a| a.is_video? ? [ :ffmpeg ] : [ :thumbnail ] }

   #  def is_video?
   #      attachment.instance.attachment_content_type =~ %r(video)
   #  end

   #  def is_image?
   #      attachment.instance.attachment_content_type =~ %r(image)
   #  end
  	
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
			self.update_attributes(state: "posted")
		rescue Exception => e			
			self.update_attributes(state: "posting error", error: e.message)
		end
	end

	def to_twitter
		client = Twitter::REST::Client.new do |config|
			config.access_token = self.user.twitter.oauth_token
			config.access_token_secret = self.user.twitter.secret
			config.consumer_key = ENV['TWITTER_KEY']
			config.consumer_secret ENV['TWITTER_SECRET']
		end
		client.update(self.content)
	end

	def to_facebook		
		graph = Koala::Facebook::API.new(self.user.facebook.oauth_token)
		graph.put_connections("me", "feed", message: self.content)

		# if self.photo.url
			# photoUrl = ApplicationController.helpers.asset_url(self.user.post.photo.url(:style))
			# graph.put_picture('https://static.pexels.com/photos/207962/pexels-photo-207962.jpeg')
		# end
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
