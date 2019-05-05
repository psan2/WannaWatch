class Movie < ActiveRecord::Base
    has_many :wannawatches

    def upcoming_movies #returns an array of all upcoming movies 
    end 

    def upcoming_movies_by_genre
    end 

    def upcoming_movies_by_series 
    end 


end
    
