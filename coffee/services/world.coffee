_=require('lodash')

world = 
	buses: []
	stops: []
	paxes: []
	get_next_stop: (stop)->
		i = (@stops.indexOf(stop) + 1)%@stops.length
		next_stop = @stops[i]

module.exports = world

