class Movie < ActiveRecord::Base
    has_many :wannawatches
    
    def self.genres
        return all.map { |movie| movie.genre}.join(", ").split(", ").reject{|genre| genre == "" }.uniq.sort_by {|genre| genre[0]}
    end

    def upcoming_movies #returns an array of all upcoming movies 
    end 

    def upcoming_movies_by_genre #returns an array of all upcoming movies  by genre
    end 

    def upcoming_movies_by_series #returns an array of all upcoming movies by series 
    end 


end
    
