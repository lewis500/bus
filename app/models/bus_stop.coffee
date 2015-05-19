World = require '../services/world'
timeout = require( '../helpers').timeout
_ = require 'lodash'
class BusStop
	constructor: (@n, @location, @flipped)->
		@alighting_paxes = []
		@boarding_paxes = []
		@busy = false
		@next_stop = undefined
		@history = []
		@snapshot = _.throttle =>
					@history.push 
						count: @boarding_paxes.length
						time: World.time
					if (World.time - @history[0].time) > (World.max_history*1000 )then @history.shift()
				, 300

	set_next: (stop)->
		@next_stop = stop

	task: (bus)->
		if World.paused
			timeout =>
					@task(bus)
				, 25
			return

		if @alighting_paxes.length > 0
			timeout =>
					alighter = @alighting_paxes.pop()
					if alighter
						alighter.alight()
						bus.remove_pax(alighter)
					@task(bus)
				, World.alight_time
		else if ((@boarding_paxes.length > 0) and (bus.queue.length < World.max_capacity))
			timeout =>
					boarder = @boarding_paxes.shift()
					if boarder
						boarder.board()
						bus.add_pax(boarder)
					@task(bus)
				, World.board_time
		else
			timeout ()=>
					@busy = false
					bus.set_next_stop(@next_stop)
					bus.release()
				, 50

	halt:(bus)->
		@busy = true
		@alighting_paxes = bus.queue.filter (pax)=> pax.destination is this
		@task(bus)

	receive_pax: (pax)->
		@boarding_paxes.push(pax)

module.exports = BusStop