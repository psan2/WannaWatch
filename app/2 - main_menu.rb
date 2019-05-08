def main_menu
    selection = $prompt.select("", per_page: 10) do |option|
        option.choice 'What do you WannaWatch?'
        option.choice 'View my list'
        option.choice 'Logout'
    end

    case selection 

    when 'What do you WannaWatch?'
        find_movies
        
    when 'View my list'
        view_my_list

    when 'Logout'
        puts "👓 Hasta la vista, baby 👓"
        $current_user = nil
        start_menu

        sleep($naptime)
    end 
end 

def view_my_list
    index = 1
    table = TTY::Table.new [' # ', 'Title                         ', 'Release Date     '], []
    $current_user.wannawatches.map do |ww| 
        table << [index, ww.movie.title, ww.movie.release_date.strftime('%d %b %Y')]
        index += 1
    end

    puts table.render(:unicode, alignments: [:center, :left, :left])

    choice = nil

    choice = $prompt.ask("Would you like to explore more? Enter the number of the movie you'd like to look at, or 0 to go back.") do |q|
        q.in("0-#{index-1}")
        q.messages[:range?] = "Couldn't find that one - try again?"
    end
    
    if choice = 0
        main_menu
    else
        description_view(Movie.find_by(title:(table[choice.to_i,1])))

    end
end

def find_movies
    selection = $prompt.select("", per_page: 10) do |option|
        option.choice 'View by series'
        option.choice 'View by genre'
        option.choice 'View all upcoming movies'
        option.choice 'View by popularity'

    end

    case selection 

    when 'View by series' 
        view_by_series
    
    when 'View by genre'
        genre = genre_picker
        view_by_genre(genre)

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

def view_by_series(series)
    series = Movie.series
    selection = $prompt.select("What series would you like to see movies from?", series, filter: true)
    movies = Movie.column_contains("series", selection).titles
    browse_movies(movies)
end

def genre_picker
    genres = Movie.genres
    selection = $prompt.select("What genre would you like to see movies from?", genres, filter: true)
end

def view_by_genre(genre)
    movies = Movie.column_contains("genre", genre).titles
    browse_movies(movies)
end

def browse_movies(movies)
    selection = $prompt.select("Pick a movie to see what it's about:", movies, filter: true)
    target_movie = Movie.find_by(title:selection)
    description_view(target_movie)
    ww_or_menu(target_movie)
    add_wannawatch(target_movie)
end

def description_view(movie)
    small_break
    puts movie.title
    border
    puts movie.description
    small_break
end

def ww_or_menu(target_movie)
    if add_ww?
        add_wannawatch(movie)
    else
        find_movies
    end
end

def add_ww?
    selection = $prompt.select("How's this look?") do |a|
        a.choice "I'd WannaWatch this!"
        a.choice "Let's pick another."
    end

    case selection
    when "I'd WannaWatch this!"
        return true

    when "Let's pick another."
        return false
    end
end

def add_wannawatch(movie)
    Wannawatch.find_or_create_by(movie_id: movie.id, user_id:$current_user.id)
    main_menu
end