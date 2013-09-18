#### IMDb Scanner

Either:
* Chuck the script (lookup.rb) into the root folder of your movies directory and run it.
* Pass the name of a file with a list of file names or paths, eg:
```
ruby lookup.rb path_to_file.txt
```
You can get a list files with the find command, like so:
```
find . >> film_list.txt
```

The films that can be found will be saved to _films.txt_ and the ones that cannot be found will go into _notfound.txt_.

Requires the JSON gem.