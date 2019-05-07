require 'uri'
require 'net/http'
require 'pry'
require 'json'
require_all 'app'
require_all 'config'

def update_movies(movie_array)
    genres = get_genres
    movie_array.each do |movie_params|
        Movie.create_with(
            description: movie_params["overview"],
            release_date: Date.strptime(movie_params["release_date"],"%Y-%m-%d"),
            title: movie_params["title"],
            genre: movie_params["genre_ids"].map{ |genre_num| genres[genre_num] }.join(', ')
            )
        .find_or_create_by(tmdb_id:movie_params["id"])
    end
end

def get_genres
    url = URI("https://api.themoviedb.org/3/genre/movie/list?language=#{$language}&api_key=#{$api_key}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    results = JSON.parse(http.request(request).read_body)

    genres_hash = {}
    results["genres"].each do |genre|
        genres_hash[genre["id"]] = genre["name"]
    end
    return genres_hash
end

def fetch(year,page=1)
    url = URI("https://api.themoviedb.org/3/discover/movie?api_key=#{$api_key}&language=#{$language}&region=#{$region}&sort_by=original_title.asc&page=#{page}&primary_release_year=#{year}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    return results_hash = JSON.parse(http.request(request).read_body)
end

def fetch_by_year(year)
    page_count = fetch(year)["total_pages"]
    page = 1
    arr_movies = []

    page_count.times do
        arr_results = fetch(year,page)["results"]
        arr_results.each { |movie| arr_movies << movie}
        page += 1
    end
    return arr_movies
end

def fetch_all
    year = $base_year
    while year <= $latest_year
        update_movies(fetch_by_year(year))
        year += 1
    end
end

def update_series(tmdb_id)
    url = URI("https://api.themoviedb.org/3/movie/#{tmdb_id}?language=en-US&api_key=be6bc01e83db5bd420caf0e567ab2965")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    results_hash = JSON.parse(http.request(request).read_body)

    Movie.find_by(tmdb_id: tmdb_id).update(imdb_id: results_hash["imdb_id"])

    if results_hash["belongs_to_collection"] != nil
        Movie.find_by(tmdb_id: tmdb_id).update(series: results_hash["belongs_to_collection"]["name"])
    end
    sleep(0.25)
end

def update_all_series
    Movie.all.each { |movie| update_series(movie.tmdb_id) }
end