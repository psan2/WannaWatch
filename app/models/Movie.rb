class Movie < ActiveRecord::Base
    has_many :wannawatches
    
    def self.genres
        return all.map { |movie| movie.genre}.join(", ").split(", ").reject{|genre| genre == "" }.uniq.sort_by {|genre| genre[0]}
    end

    def self.titles
        return all.map { |movie| movie.title }.sort
    end

    def self.term_in_column(term, selection)
        return Movie.where("#{term} LIKE ?", "#{selection}")
    end

    def upcoming_movies #returns an array of all upcoming movies 
        
    end 

    def upcoming_movies_by_genre #returns an array of all upcoming movies  by genre
    end 

    def upcoming_movies_by_series #returns an array of all upcoming movies by series 
    end 


end
    
