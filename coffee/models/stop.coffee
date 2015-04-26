Settings = require '../Settings'

class BusStop
	constructor: (@n, @location)->
		@alighting_pax = []
		@boarding_pax = []

	task: (bus)->
		if alighting_paxes.length > 0
			d3.timer(=>
				pax = alighting_paxes.shift()
				bus.remove_pax(pax)
				pax.alight()
				task(bus)
				true
			, Settings.alight_time)
		else if @boarding_pax.length > 0
			d3.timer(=>
				boarding_pax = @boarding_pax.shift()
				boarding_pax.board()
				task(bus)
				true
			, Settings.board_time)
		else bus.release()

	halt:(bus)->
		@alighting_paxes = bus.queue.filter (pax)=> pax.destination is this
		task(bus)

	receive_pax: (pax)->
		@boarding_pax.push(pax)

module.exports = Stop