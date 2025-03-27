def map_to_range(value, in_min, in_max, out_min, out_max)
  # Map the value from the input range to the output range using the linear equation
  out_value = ((value - in_min) * (out_max - out_min).to_f) / (in_max - in_min) + out_min
  return out_value
end

def draw_chart(data_series)
  x_min = nil
  x_max = nil
  y_min = nil
  y_max = nil

  data_series.each do |series|
    series.each do |point|
      x_min = point[0] if x_min.nil?
      x_max = point[0] if x_max.nil?
      y_min = point[1] if y_min.nil?
      y_max = point[1] if y_max.nil?
      x_min = point[0] if point[0] < x_min
      x_max = point[0] if point[0] > x_max
      y_min = point[1] if point[1] < y_min
      y_max = point[1] if point[1] > y_max
    end
  end
  x_min -= (x_max - x_min)*0.1
  x_max += (x_max - x_min)*0.1
  y_min -= (y_max - y_min)*0.1
  y_max += (y_max - y_min)*0.1
  

  svg_x = 500
  svg_y = 500
  svg = "<svg width='#{svg_x}' height='#{svg_y}' xmlns='http://www.w3.org/2000/svg'>"
    svg_x_range = x_max - x_min
    svg_x_scale = svg_x.to_f / svg_x_range
    # svg_x_0 = (1 - x_min) * svg_x_scale
    svg_x_0 = map_to_range(0, x_min, x_max, 0, svg_x)
    if x_min <= 0 and x_max >= 0
      svg += "<line x1='#{svg_x_0}' y1='0' x2='#{svg_x_0}' y2='#{svg_y}' style='stroke:black;stroke-width:2' />"
    end
    svg_y_range = y_max - y_min
    svg_y_scale = svg_y.to_f / svg_y_range
    #svg_y_0 = (1 - y_min) * svg_y_scale
    svg_y_0 = map_to_range(0, y_min, y_max, 0, svg_y)
    if y_min <= 0 and y_max >= 0
      svg +=  "<line x1='0' y1='#{svg_y - svg_y_0}' x2='#{svg_y}' y2='#{svg_y - svg_y_0}' style='stroke:black;stroke-width:2' />"
    end

    data_series.each do |series|
      series.each do |point|
        # x = svg_x_0 + point[0] * svg_x_scale
        # y = svg_y_0 + point[1] * svg_y_scale
        x = map_to_range(point[0], x_min, x_max, 0, svg_x)
        y = map_to_range(point[1], y_min, y_max, 0, svg_y)
        svg += "<circle r='3' cx='#{x}' cy='#{svg_y - y}' fill='grey'>"
        svg += "<title>"
        svg += (point[2] + ": ") if point.size >=3
        svg += "#{point[0]}, #{point[1]}</title>"
        svg += "</circle>"
      end
    end
  svg += "</svg>"
  svg
end
