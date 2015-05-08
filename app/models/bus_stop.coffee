Settings = require '../services/Settings'
timeout = require( '../helpers').timeout

class BusStop
	constructor: (@n, @location)->
		@alighting_paxes = []
		@boarding_paxes = []
		@next_stop = undefined

	set_next: (stop)->
		@next_stop = stop

	task: (bus)->
		if @alighting_paxes.length > 0
			setTimeout(=>
				alighter = @alighting_paxes.pop()
				if alighter
					alighter.alight()
					bus.remove_pax(alighter)
				@task(bus)
			, Settings.alight_time)
		else if ((@boarding_paxes.length > 0) and (bus.queue.length < Settings.max_capacity))
			setTimeout(=>
				boarder = @boarding_paxes.shift()
				if boarder
					boarder.board()
					bus.add_pax(boarder)
				@task(bus)
			, Settings.board_time)
		else
			timeout ()=>
					bus.set_next_stop(@next_stop)
					bus.release()
				, 25

	halt:(bus)->
		@alighting_paxes = bus.queue.filter (pax)=> pax.destination is this
		@task(bus)

	receive_pax: (pax)->
		@boarding_paxes.push(pax)

module.exports = BusStop