require_all 'app'

$prompt = TTY::Prompt.new

def startup
    welcome
    start_menu
end

def break_
    puts ""
end 

def welcome
    
    glasses_animation

    break_
    break_
    break_ 

    greeting

    break_
    break_ 

    
end

def greeting 
    hello_user = Artii::Base.new :font => 'slant'
    puts hello_user.asciify('Welcome to WannaWatch!')
end 

def start_menu
    selection = $prompt.select("", per_page: 10) do |option|
        option.choice 'Create a new user'
        option.choice 'Log in with an existing user'
        option.choice 'Quit'
    end

    case selection

    when 'Create a new user'
        new_user
        start_menu

    when 'Log in with an existing user'
        puts "Welcome back!"
        login

    when 'Quit'
        quit

    end
end

def quit
    puts "Thanks for watching!"
end



def new_user
    puts "We're glad you're here!"

    username = new_username
    password = new_password

    User.create(name:username, password:password)
    return
end

def new_username
    username_exists = true

    until username_exists == false
        username = $prompt.ask("Please enter a username.")
        username_exists = User.where(name: username).length > 0
        if username_exists == true
            puts "Unfortunately for Forrest Gump, this seat's taken. And so is that username."
        end
    end
    puts "Welcome to WannaWatch, #{username}!"
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
            puts "Obi-Wan says, 'These aren't the passwords you're looking for.' Unfortunately, your passwords didn't match. Let's try again."
        else
            puts "Nice one! Accelerating to 88 miles per hour..."
            sleep 2
        end
    end

    return User.hash_password(password1)
end

def login

    username = $prompt.ask("Please enter your username.")
    if User.find_by(name: username)
        puts "Welcome back, #{username}!"
        User.find_by(name: username).authenticate

    else
        puts "What we've got here is a failure to communicate! (No, really - we couldn't find your username.) Would you like to try again?"
    end


end
