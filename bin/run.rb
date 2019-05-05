require_relative('../config/environment.rb')

binding.pry

def update
    update_upcoming_movies(fetch_all_pages)
end