def main_menu(current_user)
    selection = $prompt.select("", per_page: 10) do |option|
        option.choice 'What do you WannaWatch?'
        option.choice 'View my list'

    end

    case selection 

    when 'What do you WannaWatch?'
        wannawatch_list
        
    when 'View my list'
        
    end 
end 


def wannawatch_list
    selection = $prompt.select("", per_page: 10) do |option|
        option.choice 'View by series'
        option.choice 'View by genre'
        option.choice 'View all upcoming movies'
        option.choice 'View by popularity'

    end

    case selection 

    when 'View by series' 
        puts 'nothing'
        #use the relevant API to select the movies by series
        #refer back to a method that does this
    
    when 'View by genre'
        view_by_genre

    when 'View all upcoming movies' 
        puts 'nothing' 
        #use the relevant API to return all the upcoming movies 
        #refer back to a method that does this
     
    when 'View by popularity'
        puts 'nothing'
        #use the relevant API to select the movies by popularity 
        #refer back to a method that does this
    
    end 
end 

def view_by_genre
    genres = Movie.genres
    selection = $prompt.select("What genre would you like to see movies from?", genres, filter: true)

    movies = Movie.term_in_column("genre", selection).titles
    selection = $prompt.select("Pick a movie to see more information", movies, filter: true)

end