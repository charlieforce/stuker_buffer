class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   validates_presence_of :time_zone

   has_many :connections, dependent: :destroy
   has_many :posts, dependent: :destroy

   def facebook
   	self.connections.where(provider: "facebook").first
   end

   def twitter
   	self.connections.where(provider: "twitter").first
   end

   def google_oauth2
    self.connections.where(provider: "google_oauth2").first
   end

   def instagram
    self.connections.where(provider: "instagram").first
   end

   def pinterest
    self.connections.where(provider: "pinterest").first
   end

   def tumblr
    self.connections.where(provider: "tumblr").first
   end

   def active_for_authentication?
     super && self.visible == true # i.e. super && self.is_active
   end

   def inactive_message
     "Sorry, this account has been deactivated."
   end
   
end
