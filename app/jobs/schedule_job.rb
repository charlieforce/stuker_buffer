class ScheduleJob < ActiveJob::Base
  queue_as :default

  def perform(post)
    post.display
  end
end
