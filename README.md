# Zwift Speed Chart

Inspired by Zwift Insider's "Tron v." scatter plots: https://zwiftinsider.com/concept-z1-vs-top-performers/

I want to build something similar, but showing ALL THE BIKES.  It isn't as pretty, but satisfies my curiosities.

### Features

![screenshot](screenshot.jpg?raw=true)

Each dot is a bike/wheel combination.  X-axis is seconds saved over an hour of flat riding.  Y-axis is seconds saved over an hour of climbing the Alpe. 

Un-upgraded bikes in grey, fully upgraded in green.  Halo bikes in red.

Mouse-hover to see the bike/wheel and time gains.

Click on a dot to highlight that bike with all wheel combinations.

Bike is highlighted in blue/purple (unupgraded, fully upgraded)


### Running

`gem install sinatra`
`ruby speed.rb`
visit `https://localhost:4567` in your browser.
