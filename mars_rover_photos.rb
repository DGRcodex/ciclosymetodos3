require 'net/http'
require 'json'

# Método para hacer la solicitud a la API y obtener los datos como un hash
def request(url)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

# Método para construir la página web con las imágenes
def build_web_page(data)
  html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"

  data["photos"].each do |photo|
    html += "<li><img src='#{photo["img_src"]}'></li>\n"
  end

  html += "</ul>\n</body>\n</html>"
  File.write("mars_rover_photos.html", html)
end

# Método para contar la cantidad de fotos por cámara
def photos_count(data)
  count_hash = Hash.new(0)
  
  data["photos"].each do |photo|
    camera_name = photo["camera"]["name"]
    count_hash[camera_name] += 1
  end
  
  count_hash
end

# URL de la API con tu propio api_key y sol=10 (10 fotos)
api_key = "Z1EA64c4O97je2QbB06Ie4ADSnSLDaPyIi4kD3ks"
url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=#{api_key}"

# Hacer la solicitud a la API
response_data = request(url)

# Construir la página web
build_web_page(response_data)

# Contar la cantidad de fotos por cámara
photo_counts = photos_count(response_data)
puts "Cantidad de fotos por cámara:"
photo_counts.each do |camera, count|
  puts "#{camera}: #{count}"
end
