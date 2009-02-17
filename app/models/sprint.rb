class Sprint < ActiveRecord::Base
	acts_as_list
	belongs_to :project
	validates_presence_of :goal

	class << self
		def create_new(project)
			sprint = self.new
			sprint.start_date = Date.today
	    sprint.end_date =  sprint.start_date + project.sprint_duration_days
			sprint
		end

		def create_next(previous_sprint)
			sprint = self.new
			sprint.start_date = previous_sprint.end_date + 1.days
		  sprint.end_date =  sprint.start_date + previous_sprint.project.sprint_duration_days
			sprint
		end
	end

	def current?
		self[:start_date] <= Date.today && self[:end_date] >= Date.today
	end

end
