require 'sinatra'
require 'csv'
require_relative 'scatter.rb'

frames_file = "frames.csv"
wheels_file = "wheels.csv"

frames_raw = CSV.read(frames_file, headers: true)
wheels_raw = CSV.read(wheels_file, headers: true)

base_wheel = "Zwift 32mm Carbon"
base_bike = "Zwift Carbon"

bike_time = []
wheel_time = []
nowheel_bike_time = []

frames_raw.each do |row|
  bike = row["Bike"]
  wheel = row["Wheels"]
  next if ["Zwift Gravel", "Zwift Mountain", "Zwift Handcycle"].include? wheel
  flat_gap = row["Flat Stage 0 - Hour Time Gap"].to_f
  climb_gap = row["Climb Stage 0 - Hour Time Gap"].to_f
  if wheel == base_wheel
    bike_time << [flat_gap, climb_gap, bike]
  elsif wheel == bike #specialty bikes
    nowheel_bike_time << [flat_gap, climb_gap, bike]
  end
end

wheels_raw.each do |row|
  bike = row["Bike"]
  wheel = row["Wheels"]
  flat_gap = row["Flat Hour Time Gap"].to_f
  climb_gap = row["Climb Hour Time Gap"].to_f
  if bike == base_bike
    wheel_time << [wheel, flat_gap, climb_gap]
  end
end

get '/' do
  draw_chart([bike_time, nowheel_bike_time])
end
