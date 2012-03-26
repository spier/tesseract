# Tesseract for Zugmonitor

WARNING: If you are looking for Tesseract by Square, please check the [original repository](ttps://github.com/square/tesseract). I have only forked that repository to work on the [gh-pages][] branch, so that I could get the [demo site](http://spier.hu/tesseract) up and running quickly.

This repository here contains the ruby code for converting the data from Zugmonitor into the CSV format that needed by the [demo site](http://spier.hu/tesseract).

# Steps

1. Create a folder **input_data**

1. Download some data from the [Zugmonitor API][] and save it in folder **input_data**. e.g. this

		curl "http://zugmonitor.sueddeutsche.de/api/trains/2012-0[1-3]-0[1-9]" -o 2012-0#1-0#2.json
		curl "http://zugmonitor.sueddeutsche.de/api/trains/2012-0[1-3]-[10-31]" -o 2012-0#1-#2.json
	
Then clean up the files that are empty (as e.g. the date 2012-02-31 does does not exist).

1. run converter
		bundle install
		ruby converter.rb
	
1. check trains.csv, should look similar to this

		date,delay,distance,origin,destination
		01011423,0,289,Aarhus,Hamburg Hbf
		01012152,5,259,Hamburg-Altona,Berlin Südkreuz
		01010757,0,455,Aarhus,Berlin Ostbahnhof
		01011810,0,635,Koebenhavn H,Praha hl.n.
		01011810,20,621,Koebenhavn H,Amsterdam Centraal
		01011810,0,968,Koebenhavn H,Basel SBB
		01011745,0,289,Koebenhavn H,Hamburg Hbf
		01011728,5,289,Hamburg Hbf,Koebenhavn H
		01011545,0,289,Koebenhavn H,Hamburg Hbf


# Credits

Calculating Haversine distance between two coordinates based on [reference 1][dist1] and [reference 2][dist2]. Using the [Haversine Distance Ruby gem][gem].


[dist1]: http://www.movable-type.co.uk/scripts/latlong.html
[dist2]: http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates
[gem]: https://rubygems.org/gems/haversine_distance

[gh-pages]: https://github.com/spier/tesseract/tree/gh-pages
[Zugmonitor API]: http://www.opendatacity.de/zugmonitor-api/