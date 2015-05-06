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
			timeout(=>
				alighter = @alighting_paxes.pop()
				if alighter 
					@task(bus)
					alighter.alight()
					bus.remove_pax(alighter)
				@task(bus)
			, Settings.alight_time)
		else if @boarding_paxes.length > 0
			timeout(=>
				boarder = @boarding_paxes.shift()
				if boarder
					boarder.board()
					bus.add_pax(boarder)
				@task(bus)
			, Settings.board_time)
		else if bus.not_ready
			timeout(=>
				@task(bus)
			, 25)
		else 
			bus.set_next_stop(@next_stop)
			bus.release()

	halt:(bus)->
		@alighting_paxes = bus.queue.filter (pax)=> pax.destination is this
		@task(bus)

	receive_pax: (pax)->
		@boarding_paxes.push(pax)

module.exports = BusStop