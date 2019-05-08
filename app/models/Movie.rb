class Movie < ActiveRecord::Base
    has_many :wannawatches
    
    def self.genres
        return all.map { |movie| movie.genre}.join(", ").split(", ").reject{|genre| genre == "" }.uniq.sort_by {|genre| genre[0]}
    end

    def self.titles(array=all)
        return array.map { |movie| movie.title }.sort
    end

    def self.column_contains(column, search_term)
        return Movie.where("#{column} LIKE ?", "%#{search_term}%")
    end

    def self.series
        return all.map { |movie| movie.series}.reject{|series| series == nil }.uniq.sort
    end

    def upcoming_movies #returns an array of all upcoming movies 
    end 

    def upcoming_movies_by_genre #returns an array of all upcoming movies  by genre
    end 

    def upcoming_movies_by_series #returns an array of all upcoming movies by series 
    end 


end
    
