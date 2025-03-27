require 'sinatra'
require_relative 'scatter.rb'

exdata1 = [
[1,1],
[1,2],
[2,1],
[10,5]
]

exdata2 = [
[-1,-1],
[-2,-2]
]

get '/test' do
  draw_chart([exdata1, exdata2])
end
