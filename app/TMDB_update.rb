require 'uri'
require 'net/http'
require 'pry'
require 'json'
require_all 'app'

def fetch(page=1)
    url = URI("https://api.themoviedb.org/3/movie/upcoming?page=#{page}&language=en-US&api_key=be6bc01e83db5bd420caf0e567ab2965")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.body = "{}"

    response = http.request(request)
    return results_hash = JSON.parse(http.request(request).read_body)
end

def fetch_all_pages
    page_count = fetch["total_pages"]
    page = 1
    arr_movies = []

    page_count.times do
        arr_results = fetch(page)["results"]
        arr_results.each { |movie| arr_movies << movie}
        page += 1
    end
    return arr_movies
end

def update_upcoming_movies(arr_movies)
    arr_movies.each do |movie_hash|
        Movie.create(
            tmdb_id: movie_hash["id"],
            title: movie_hash["title"],
            description: movie_hash["overview"],
            release_date: Date.strptime(movie_hash["release_date"],"%Y-%m-%d")
        )
    end
end
