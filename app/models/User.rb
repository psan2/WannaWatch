class User < ActiveRecord::Base
    has_many :wannawatches

    def self.new_user
        puts "We're glad you're here! Please enter a username:"

        username = new_username
        password = new_password

        User.create(name:username, password:password)
        return
    end

    def self.new_username
        username_exists = true

        until username_exists == false
            username = gets.chomp
            username_exists = User.where(name: username).length > 0
            if username_exists == true
                puts "Unfortunately for Forrest Gump, this seat's taken. And so is that username. Please enter a different username."
            end
        end
        return username
    end

    def self.new_password
        puts "Thanks!  Now, please enter a password:"
        password1 = "1"
        password2 = "2"

        until password1 == password2
            password1 = gets.chomp

            puts "Just to make sure, please enter that password one more time:"
            password2 = gets.chomp

            if password1 != password2
                puts "Obi-Wan says, 'These aren't the passwords you're looking for.' Unfortunately, your passwords didn't match. Please re-enter your password."
            end
        end

        return password1
    end

    # def log_in
    # end 


    # def log_out
    # end 

    # def add_a_watch 
    # end 

    # def return_watch_list 
    # end 



end
    
