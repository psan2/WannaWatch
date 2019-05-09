def startup
    welcome
    start_menu
end

def welcome
    glasses_animation
    small_break

    hello_user = Artii::Base.new :font => 'slant'
    puts hello_user.asciify('Welcome to WannaWatch!')
    small_break
end

def start_menu
    puts <<-text
WannaWatch lets you keep track of movies that you, well, want to watch!
This tool uses data from #{Rainbow("TheMovieDB API").italic} to ensure we have the most updated
information on upcoming releases, and access their huge library to ensure
that we can track almost any movie ever made. The only question left is...

#{Rainbow("What do you WannaWatch?").bold}
    text
    selection = nil
    until selection == 'Quit'
        selection = $prompt.select("", per_page: 10) do |a|
            a.choice 'New user'
            a.choice 'Log in'
            a.choice 'Quit'
        end

        case selection

        when 'New user'
            new_user

        when 'Log in'
            login

        when 'Quit'
            quit
        end
    end
end

def login

    username = $prompt.ask("Please enter your username.")
    if User.find_by(name: username)
        User.find_by(name: username).authenticate

    else
        puts "#{random_quotes_generator($errors)} (No, really - we couldn't find your username.)"

        selection = $prompt.select("Try again?") do |a|
            a.choice 'Try again'
            a.choice 'Click your heels three times (to go back to the menu)'
        end

        case selection

        when 'Try again'
            login

        when 'Click your heels three times (to go back to the menu)'
            return
        end
    end

end

def new_user
    puts random_quotes_generator($greetings)

    username = new_username
    if username == "exit"
        return
    end

    password = new_password
    if password != "exit"
        $current_user = User.create(name:username, password:password)
        main_menu
    end
end

def new_username
    username_exists = true
    username = nil

    until username_exists == false || username == "exit"
        username = $prompt.ask("Please enter a username.")

        if username == "exit"
            return username
        end

        username_exists = User.where(name: username).length > 0
        if username_exists == true
            puts "#{random_quotes_generator($errors)}.\nNo, really - that username's already taken."
            small_break
        end
    end

    puts random_quotes_generator($greetings)
    return username
end

def new_password
    password1 = "1"
    password2 = "2"

    until password1 == password2
        password1 = $prompt.mask("Please enter a password:")
        if password1 == "exit"
            return "exit"
        end

        password2 = $prompt.mask("Just to make sure, please enter that password one more time:")
        if password2 == "exit"
            return "exit"
        end

        if password1 != password2
            puts "#{random_quotes_generator($errors)} Unfortunately, your passwords didn't match. Let's try again."

        else
            puts random_quotes_generator($greetings)
            sleep($naptime)
        end
    end

    return User.hash_password(password1)
end

def quit
    puts random_quotes_generator($goodbyes)
    exit
end
