class Todoitem < ActiveRecord::Base
	belongs_to  :user
	def expired
		DateTime.now>start_time
	end
	def priority_string
		case priority
			when 1
				"High"
			when 2
				"Medium"
			when 3
				"Low"
		end
	end
end