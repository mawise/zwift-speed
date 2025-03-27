require 'sinatra'
require 'csv'
require_relative 'scatter.rb'


def get_data(selection={})
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
    next if ["Zwift Gravel", "Zwift Mountain"].include? wheel
    next if ["Zwift BMX Bandit", "Zwift Safety", "Zwift Buffalo Fahrrad", "Zwift Handcycle", "Zwift Atomic Cruiser"].include? bike
    flat_gap = row["Flat Stage 0 - Hour Time Gap"].to_f
    flat5_gap = row["Flat Stage 5 - Hour Time Gap"].to_f
    climb_gap = row["Climb Stage 0 - Hour Time Gap"].to_f
    climb5_gap = row["Climb Stage 5 - Hour Time Gap"].to_f
    if wheel == base_wheel
      bike_time << [bike, flat_gap, climb_gap]
      bike_time << ["#{bike} Stage 5", flat5_gap, climb5_gap]
    elsif ["Cannondale R4000 Roller Blade", "Zwift Concept Z1", "Pinarello Espada", "Specialized PROJECT 74"].include? bike #specialty bikes
      nowheel_bike_time << [bike, flat_gap, climb_gap]
      nowheel_bike_time << ["#{bike} Stage 5", flat5_gap, climb5_gap]
    end
  end
  
  wheels_raw.each do |row|
    bike = row["Bike"]
    wheel = row["Wheels"]
    next if bike == "Zwift TT"
    next if ["Zwift Atomic Cruiser 2024", "Zwift Buffalo Fahrrad", "Zwift Safety"].include? wheel
    flat_gap = row["Flat Hour Time Gap"].to_f
    climb_gap = row["Climb Hour Time Gap"].to_f
    if bike == base_bike
      wheel_time << [wheel, flat_gap, climb_gap]
    end
  end
  
  combined_times = []
  bike_time.each do |bike_row|
    wheel_time.each do |wheel_row|
      title = bike_row.first + "+" + wheel_row.first
      link_url = "/bike/#{bike_row.first.split(" Stage 5").first}"
      flat = bike_row[1] + wheel_row[1]
      climb = bike_row[2] + wheel_row[2]
      style={}
      style[:rad] = 3
      style[:color] = "grey"
      style[:alpha] = "0.3"
      if !!selection[:bike] and bike_row.first.start_with? selection[:bike]
        style[:color] = "blue"
        style[:rad] = 4
        style[:alpha] = "1"
        if bike_row.first.end_with? " Stage 5"
          style[:color] = "purple"
        end
      elsif bike_row.first.end_with? " Stage 5"
        style[:color] = "lightgreen"
      end
      combined_times << [flat, climb, title, style, link_url]
    end
  end
  nowheel_bike_time.each do |time|
    bike = time[0]
    flat = time[1]
    climb = time[2]
    style={}
    style[:rad] = 5
    style[:color] = "red"
    style[:alpha] = "1"
    if bike.end_with? " Stage 5"
      style[:color] = "pink"
    end
    combined_times << [flat, climb, bike, style]
  end  
  return combined_times
end

get '/' do
  data = get_data()
  draw_chart(data)
end

get '/bike/:bikename' do
  data = get_data({bike: params[:bikename]})
  draw_chart(data)
end
