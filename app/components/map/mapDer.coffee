angular = require 'angular'
World = require '../../services/world'
Data = require '../../services/data'
textures = require 'textures'
_ = require 'lodash'

class MapCtrl
	constructor: (@scope, @element, @window) ->
		sel =  d3.select @element[0]
		@road = sel.select 'path#road'
			.node()
		@Data = Data

	place_bus: (d)->
		percent = d.location / World.road_length
		road_length = @road.getTotalLength()
		p0 = @road.getPointAtLength percent*road_length
		p = @road.getPointAtLength (percent+.002)%1*road_length
		angle = 180/Math.PI * Math.atan2 p.y - p0.y, p.x - p0.x 
		"translate( #{p0.x} , #{p0.y} ) rotate( #{angle} )"
		
	place_stop: (d)->
		road_length = @road.getTotalLength()
		percent = d.location / World.road_length
		p = @road.getPointAtLength percent*road_length
		p0 = @road.getPointAtLength (percent+.001)%1*road_length
		angle = -Math.atan2 p.y - p0.y , p.x - p0.x
		g = [55*Math.sin( angle), 55*Math.cos( angle)]
		x = if d.flipped then (p.x - g[0]) else (p.x + g[0])
		y = if d.flipped then (p.y - g[1]) else (p.y + g[1])
		"translate(#{x},#{y})"

der = ()->
	directive = 
		templateUrl: './styles/picture3-01.svg'
		controller: ['$scope','$element','$window', MapCtrl]
		# restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		# replace: true
		templateNamespace: 'svg'
		scope: {}

module.exports = der
