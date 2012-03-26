#!/usr/bin/env ruby

#
# Converts JSON data from the Zugmonitor API into the CSV file
# format needed by http://spier.hu/tesseract
#

require 'rubygems'
require "bundler"
Bundler.setup
Bundler.require(:default)

require 'pp'
require 'logger'
require 'time'
require 'csv'

@log = Logger.new(STDOUT)

# ---------------------------------------------

Stations = JSON[open("stations.json").read]

def get_station(fixnum_id)
  str_id = fixnum_id.to_s
  Stations[ str_id ]
end

def calculation_distance(s1,s2)
  km = Haversine.distance(s1["lat"], s1["lon"], s2["lat"], s2["lon"]);
  #puts "#{s1["name"]} => #{s2["name"]}: #{km}"
  km = sprintf('%.0f', km)
  #puts "#{s1["name"]} => #{s2["name"]}: #{km}"
end

# ---------------------------------------------

csv_file = CSV.open("trains.csv", "wb")
csv_file << ["date", "delay", "distance", "origin","destination"]

begin

Dir.glob("input_data/*.json").each do |file|
  @log.info "Processing: #{file}"

  trains = JSON[open(file).read]
  trains = trains.values
  trains = trains.select{|t| t["status"] == "F"}
  @log.debug "Finished trains: #{trains.size}"

  # for reach train generate one CSV entry
  trains.each do |train|
    # stations
    s_from = get_station(train["stations"].first["station_id"])
    s_to = get_station(train["stations"].last["station_id"])

    # put together date
    departure = Time.local(
      train["date"][0],
      train["date"][1] + 1,
      train["date"][2],
      train["stations"].first["departure"] / 60,
      train["stations"].first["departure"] % 60
    )

    # delay
    delay = train["stations"].last["delay"] || 0

    # write to CSV
    # format: 01010001,14,405,MCI,MDW
    csv_file << [
      departure.strftime("%m%d%H%M"),
      delay,
      calculation_distance(s_from, s_to),
      s_from["name"],
      s_to["name"]
    ]
  end
end

rescue Exception => e
  puts "error"
end

