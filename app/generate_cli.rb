$prompt = TTY::Prompt.new

def startup
    welcome
    start_menu
end

def welcome
    puts "Welcome to WannaWatch!"
end

def start_menu
    menu = TTY::Prompt.new

    selection = menu.select("", per_page: 10) do |option|
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




def main_menu(current_user)
    mainmenu = TTY::Prompt.new 

    selection = mainmenu.select("", per_page: 10) do |option|
        option.choice 'What do you WannaWatch?'
        option.choice 'View my list'

    end

    case selection 

    when 'What do you WannaWatch?'
        WannaWatch_list
        
    when 'View my list'
        
    end 
end 


def WannaWatch_list
    list = TTY::Prompt.new 

    selection = list.select("", per_page: 10) do |option|
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
        puts 'nothing'
        #use the relevant API to select the movies by genre 
        #refer back to a method that does this

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
    




