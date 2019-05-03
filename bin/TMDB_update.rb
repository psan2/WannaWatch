require 'uri'
require 'net/http'
require 'pry'
require 'json'

url = URI("https://api.themoviedb.org/3/movie/upcoming?page=1&language=en-US&api_key=be6bc01e83db5bd420caf0e567ab2965")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request.body = "{}"

response = http.request(request)
movies_hash = JSON.parse(http.request(request).read_body)
binding.pry

return