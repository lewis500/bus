class Stop
	constructor: (@n, @location)->
		@queue = []
	receive_pax: (pax)->
		@queue.push(pax)
	remove_pax: (pax)->
		@queue.splice(@queue.indexOf( pax), 1)

module.exports = Stop