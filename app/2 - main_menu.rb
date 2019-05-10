def main_menu
    selection = nil
    until selection == 'Logout'
        selection = $prompt.select("", per_page: 10) do |a|
            a.choice 'What do you WannaWatch?'
            a.choice 'View my list'
            a.choice 'Leaderboards'
            a.choice 'Logout'
            a.choice 'Quit'
        end

        case selection

        when 'What do you WannaWatch?'
            find_movies

        when 'View my list'
            view_my_list

        when "Leaderboards"
            leaderboards

        when 'Logout'
            random_quotes_generator($goodbyes)
            $current_user = nil
            return

            sleep($naptime)

        when 'Quit'
            random_quotes_generator($goodbyes)
            exit
        end
    end
    return
end

def find_movies
    selection = $prompt.select("", per_page: 10) do |a|
        a.choice 'Browse by title'
        a.choice 'Browse by series'
        a.choice 'Browse by genre'
        a.choice 'Browse future releases'
        a.choice "Can't find a movie in our library?"
        a.choice "Back to the menu"
    end

    case selection
    when 'Browse by title'
        browse_movies(Movie.all)

    when 'Browse by series'
        series = series_picker
        browse_by_series(series)

    when 'Browse by genre'
        genre = genre_picker
        browse_by_genre(genre)

    when 'Browse future releases'
        browse_movies(Movie.all.where("release_date > ?",Date.today))

    when "Can't find a movie in our library?"
        search_new_movie

    when "Back to the menu"
        return
    end
end

def series_picker
    series = Movie.series
    selection = $prompt.select("What series would you like to see movies from?", series, filter: true)
end

def browse_by_series(series)
    movies = Movie.column_contains("series", series)
    browse_movies(movies)
end

def genre_picker
    genres = Movie.genres
    selection = $prompt.select("What genre would you like to see movies from?", genres, filter: true)
end

def browse_by_genre(genre)
    movies = Movie.column_contains("genre", genre)
    browse_movies(movies)
end

def search_new_movie
    puts "To keep things speedy, our database only stores movies from the year 2000 onward. But fear not! We can find your favorite."
    search_term = $prompt.ask("What's it called? (enter a full or partial title)")

    spinner = TTY::Spinner.new("[:spinner] Consulting the hive mind...", format: :pulse_2)
    spinner.auto_spin
    search_all_pages(search_term)
    spinner.stop('Done!')
    browse_movies(Movie.all.where("title LIKE ?","%#{search_term}%"))
end

def browse_movies(movies)
    if movies.length == 0
        puts "#{random_quotes_generator($errors)}\nSorry, no movies were found. Please try again."
        return
    end
    parsed = []
    movies.each { |movie| parsed << "#{movie.title}" + Rainbow("###{movie.tmdb_id}").hide }
    selection = $prompt.multi_select("Check the movies you'd like to add to your list.\nYou can select just one to see more about it!", parsed, filter: true)
    arr_ids = selection.map { |movie| movie.split("##")[1].to_i}
    if arr_ids.length == 0
        try_again = $prompt.select("#{random_quotes_generator($errors)}\n You haven't selected any movies! Would you like to try again?") do |a|
            a.choice 'Try again'
            a.choice 'Take me to the menu!'

            case try_again
            when 'Try again'
                browse_movies(movies)
            when 'Take me to the menu!'
                return
            end
        end
    elsif arr_ids.length == 1
        description_view(arr_ids)
        add_wannawatch(arr_ids)
    else
        add_wannawatch(arr_ids)
    end
end

def view_my_list
    index = 1
    table = nil
    table = TTY::Table.new [
        Rainbow(" # ").bold.blue,
        Rainbow("Title                  ").bold.blue,
        Rainbow("Genre          ").bold.blue,
        Rainbow("Release Date           ").bold.blue], []
    $current_user.wannawatches.sort_by { |ww| ww.movie.release_date }.map do |ww|
        table << [index, ww.movie.title, ww.movie.genre.split(", ")[0..3].sort.join(", "), ww.movie.release_date.strftime('%d %b %Y')]
        index += 1
    end

    puts table.render(:unicode, alignments: [:center, :left, :left, :left],width:150,resize:true)

    choice = $prompt.ask("Would you like to explore more? Enter the number of the movie you'd like to look at, or 0 to go back.") do |q|
        q.in("0-#{index-1}")
        q.messages[:range?] = "Please enter a valid number."
    end


    if choice.to_i == 0
        return
    else
        arr_ids = []
        movie = Movie.find_by(title:table[choice.to_i-1,1])
        arr_ids << movie.tmdb_id
        description_view(arr_ids)
        browse_others_like(movie)
    end
end

def leaderboards
    selection = $prompt.select("", per_page: 10) do |a|
        a.choice 'See users who WannaWatch the most'
        a.choice 'See the most WannaWatched movies'
        a.choice 'Go back'
    end

    case selection

    when 'See users who WannaWatch the most'
        top_users

    when 'See the most WannaWatched movies'
        top_wws

    when 'Go back'
        return
    end
end

def top_users
    top_users = {}

    User.all.map { |user| top_users[user] = user.wannawatches.length }

    table = TTY::Table.new [
        Rainbow("User").bold.blue,
        Rainbow("WannaWatches   ").bold.blue], []

    top_users.sort_by { |user, count| count}.reverse!.map do |user, count|
        table << [
            if user == $current_user
                Rainbow(user.name).bold.red
            else
                user.name
            end,
            count
        ]
    end

    puts table.render(:unicode, alignments: [:left,:center],width:150,resize:true)

    try_again = $prompt.select("") do |a|
        a.choice 'Continue?'
            return
    end
end

def top_wws
    top_wws = {}

    ww_movies = Wannawatch.all.map { |ww| ww.movie }.uniq
    ww_movies.map { |movie| top_wws[movie] = movie.wannawatches.length }

    index = 1
    table = TTY::Table.new [
        Rainbow(" # ").bold.blue,
        Rainbow("Title                  ").bold.blue,
        Rainbow("Release Date           ").bold.blue,
        Rainbow("Users Watching").bold.blue], []

    top_wws.sort_by { |movie, count| count}.reverse!.map do |movie, count|
        table << [index, movie.title, movie.release_date.strftime('%d %b %Y'), count]
        index += 1
    end

    puts table.render(:unicode, alignments: [:center, :left, :left, :left],width:150,resize:true)

    choice = $prompt.ask("Would you like to explore more? Enter the number of the movie you'd like to look at, or 0 to go back.") do |q|
        q.in("0-#{index-1}")
        q.messages[:range?] = "Please enter a valid number."
    end

    if choice.to_i == 0
        return
    else
        arr_ids = []
        movie = Movie.find_by(title:table[choice.to_i-1,1])
        arr_ids << movie.tmdb_id
        description_view(arr_ids)
        browse_others_like(movie)
    end
end

def description_view(arr_ids)
    small_break
    movie = Movie.find_by(tmdb_id:arr_ids[0])

    puts movie.title
    border

    puts "Release date: #{movie.release_date.strftime('%d %b %Y')}"
    puts "Genre: #{movie.genre}"
    if movie.series != nil
        puts "Series: #{movie.series}"
    end
    small_break
    border
    small_break
    puts movie.description
    small_break
    small_break

end

def browse_others_like(movie)
    selection = $prompt.select("", per_page: 10) do |a|
        a.choice 'Browse other movies from this genre'
        if movie.series != nil
            a.choice 'Browse other movies from this series'
        end
        a.choice "Don't WannaWatch this anymore?"
        a.choice 'Main menu'

    end

    case selection

    when 'Browse other movies from this genre'
        browse_by_genre(movie.genre)

    when "Don't WannaWatch this anymore?"
        delete_it = $prompt.select("Are you sure?") do |a|
            a.choice "Axe it"
            a.choice "I've seen it"
            a.choice "Wait, keep it"
        end

        case delete_it
        when "Axe it", "I've seen it"
            Wannawatch.find_by(user_id:$current_user, movie_id:movie.id).destroy
            $current_user = User.find_by(id:$current_user.id)
            puts "Pew pew pew. It's gone."
            small_break

        when "Wait, keep it!"
            puts "No worries - haven't changed a thing!"
            small_break
            sleep($naptime)
        end

    when 'Browse other movies from this series'
        browse_by_series(movie.series)

    when 'Main menu'
        return
    end
end

def add_wannawatch(arr_ids)
    small_break
    border
    small_break

    movies = arr_ids.map { |tmdb_id| Movie.find_by(tmdb_id:tmdb_id).title}
    selection = $prompt.select("#{movies.join("\n")}") do |a|
        if arr_ids.length == 1
            a.choice "I'd WannaWatch this!"
        else
            a.choice "I'd WannaWatch these!"
        end
        a.choice "Let's pick another."
    end

    case selection
    when "I'd WannaWatch these!", "I'd WannaWatch this!"
        arr_ids.each do |tmdb_id|
            id = Movie.find_by(tmdb_id:tmdb_id).id
            Wannawatch.find_or_create_by(movie_id: id, user_id:$current_user.id)
        end
        small_break
        $current_user = User.find_by(id:$current_user.id)
        puts "Happy watching!"

    when "Let's pick another."
        return
    end
end
