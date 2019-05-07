# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Time::DATE_FORMATS[:due_date] = "due on %B %d %y at %I:%M %p"
