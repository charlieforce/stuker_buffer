Rails.application.config.middleware.use OmniAuth::Builder do
	# provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]
	# provider :facebook, ENV["FACEBOOK_ID"], ENV["FACEBOOK_SECRET"], scope: 'email,publish_actions'

	provider :twitter, 'uPeNCwSluigzuA39sF3NM9gfD', 'E3vS7fUCz6fEV3oQcEprVoeRMrlLwg5CF5mLYFY5UEGxMVswSA'	

	provider :facebook, '1859291274333211', '841466c0d33a992b80971796a7dbee5e', scope: 'publish_actions, public_profile, email'
	# provider :facebook, '106702919884862', '426502b45bf077d08bdb578d67dd7a41', scope: 'publish_actions, public_profile, email'
	
	provider :google_oauth2, '645884706355-6lv863g5dmaoeli6qvgotqfufecucpid.apps.googleusercontent.com', 'bbPPTt010cygHO8Od-FXn9pB', { scope: ['email', 'https://www.googleapis.com/auth/gmail.modify'], access_type: 'offline'}

	provider :pinterest, '4906555513858179839', 'edadecb06fe0b2df78faaa3f0a0df359e67744a7c9e5316724d246fc38bce5f0'

	provider :instagram, '1f4e5dcab203491da9aa909d3127427c', '38b0383c6ae646e5b4a311b6ce0b6fce', scope: 'basic'

	provider :tumblr, 'NDcc75IRbBLxSbqLLH7j6m8RbKDcP8u9JsZbX3PTaefp9XKzcS', 'I6bn027bJc3DJQxbDcgOS7oAcDoq9SltEd4UBZILDdVoagLTyU'
end

OmniAuth.config.on_failure = Proc.new do |env|
	ConnectionsController.action(:omniauth_failure).call(env)
end

#config/initalizers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  
end