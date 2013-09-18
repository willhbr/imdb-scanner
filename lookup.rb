#! /usr/local/rvm/rubies/ruby-1.9.3-p392/bin/ruby
# Developed by Javanut13. IMDb searches performed with mymovieapi.com.

require 'net/http'
require 'json'

def lookup_movie(filename, output, notfound)
  query = filename
  query = query[0..-5].downcase.gsub(".", " ").gsub(/[-_]/, " ").gsub(/\(.*?\)/, "")
  query = query.gsub(/dvd.*|bluray.*|eng .*|hq.*|xvid.*|cd .*|cd\d.*|1080p.*|720p.*/, "").squeeze(" ").strip
  query = query.gsub(/\d{4}$/, "").gsub(/\[.*/, "")
  if query.end_with? "the"
    query = "the " + query[0..-4]
  end
  response = Net::HTTP.get_response("mymovieapi.com","/?title=#{query.gsub(" ", "+")}&type=json&plot=simple&limit=1&yg=0&mt=none&lang=en-US&release=simple&business=0&tech=0")
  jason = JSON.parse(response.body)[0]
  
  if jason == nil
    notfound.puts "#{filename} (Searched for '#{query}')"
  else
    output.puts ("-" * 20) + filename + ("-" * 20)
    output.puts "#{jason["title"]} - #{jason["rating"]}"
    output.puts jason["plot_simple"]
  end
end

def do_film(item, output, notfound)
  if VALID_ENDINGS.collect {|e| item.downcase.end_with? e}.any?
    lookup_movie(item, output, notfound)
  end
end
VALID_ENDINGS = ["avi", "mp4"]
def do_folder(path, output, notfound, completed)
  Dir.foreach(path) do |item|
    next if item == '.' or item == '..'
    if File.directory? item
      do_folder(item, output, notfound, completed)
    else
      do_film(item, output, notfound)
      completed += 1
      print "Completed #{completed}\r"
    end
  end
end

def from_file(file, output, notfound)
  File.read(file).split("\n").each do |path|
    item = path.split("/")[-1]
    do_film(item, output, notfound)
  end
end

path = Dir.pwd
filename = "films.txt"
notfoundname = "notfound.txt"
output = File.open(filename, "w")
notfound = File.open(notfoundname, "w")

if !ARGV[0]
  do_folder(path, output, notfound, 0)
else
  from_file(ARGV[0], output, notfound)
end
puts "\nFinished\nFilm list in #{filename}\nFilms not found in #{notfoundname}"

output.close
notfound.close
