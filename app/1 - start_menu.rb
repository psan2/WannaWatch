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
<<<<<<< HEAD
    puts "Welcome to WannaWatch!"
    # glasses_animation
=======
    
    glasses_animation

    break_
    break_
    break_ 

    greeting

    break_
    break_ 

    
>>>>>>> master
end

def greeting 
    hello_user = Artii::Base.new :font => 'slant'
    puts hello_user.asciify('Welcome to WannaWatch!')
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
    sleep($naptime)

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
            sleep($naptime)
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
            sleep($naptime)
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
        puts "What we've got here is a failure to communicate! (No, really - we couldn't find your username.)"
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
