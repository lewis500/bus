Settings = require '../services/Settings'
timeout = require( '../helpers').timeout

class BusStop
	constructor: (@n, @location)->
		@alighting_pax = []
		@boarding_pax = []

	task: (bus)->
		if @alighting_paxes.length > 0
			timeout(=>
				pax = alighting_paxes.shift()
				bus.remove_pax(pax)
				pax.alight()
				@task(bus)
			, Settings.alight_time)
		else if @boarding_pax.length > 0
			timeout(=>
				boarding_pax = @boarding_pax.shift()
				boarding_pax.board()
				@task(bus)
			, Settings.board_time)
		else if bus.not_ready
			timeout(=>
				@task(bus)
			, 25)
		else bus.release()

	halt:(bus)->
		@alighting_paxes = bus.queue.filter (pax)=> pax.destination is this
		@task(bus)

	receive_pax: (pax)->
		@boarding_pax.push(pax)

module.exports = BusStop