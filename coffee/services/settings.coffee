
settings = 
	road_length: 100
	num_buses: 4
	num_stops: 4
	gap: 2
	scale: 1
	bus_velocity: .01
	_boarding: 500
	_alighting: 500
	_add_time: 3500
	board_time: ()-> @scale * @_boarding
	alight_time: ()-> @scale * @_alighting
	add_time: ()-> @scale* @_add_time
	headway: ()->
		travel_time = @road_length / @bus_velocity / @num_stops
		pax_time = (@board_time() + @alight_time() ) / @add_time()
		H = travel_time / (1-pax_time)

module.exports = settings
