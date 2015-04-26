
class Settings =
	constructor: ()->
	road_length: 100
	num_buses: 4
	num_stops: 4
	space: 1
	scale: 1
	bus_velocity: .01
	_boarding: 500
	_alighting: 500
	_add_time: 3500
	@property 'board_time', get: ->@scale * @_boarding
	@property 'alight_time', get: -> @scale * @_alighting
	@property 'add_time', get: -> @scale @_add_time
	@property 'headway', get:->
		travel_time = @road_length / @bus_velocity / @num_stops
		pax_time = (@board_time() + @alight_time() ) / @add_time()
		H = travel_time / (1-pax_time)

module.exports = new Settings()
