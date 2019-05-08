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

    puts random_quotes_generator($greetings)
end

def start_menu
    selection = $prompt.select("", per_page: 10) do |a|
        a.choice 'New user'
        a.choice 'Log in'
        a.choice 'Quit'
    end

    case selection

    when 'New user'
        new_user
        start_menu

    when 'Log in'
        login

    when 'Quit'
        quit

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
            start_menu
        end
    end
end

def new_user
    puts random_quotes_generator($greetings)

    username = new_username
    password = new_password

    User.create(name:username, password:password)
    return
end

def new_username
    username_exists = true

    until username_exists == false
        username = $prompt.ask("Please enter a username.")

        if username == "exit"
            start_menu
        end

        username_exists = User.where(name: username).length > 0
        if username_exists == true
            puts "Unfortunately for Forrest Gump, this seat's taken. And so is that username."
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
            start_menu
        end

        password2 = $prompt.mask("Just to make sure, please enter that password one more time:")
        if password2 == "exit"
            start_menu
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
end
