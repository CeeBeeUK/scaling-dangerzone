class NewsRelease < ActiveRecord::Base

  validates :title, :released_on, :body, presence: true

	def title_with_date
		"#{released_on.strftime('%Y-%m-%d')}: #{title}"
	end
end
