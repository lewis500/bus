angular = require 'angular'
World = require '../../services/world'
Data = require '../../services/data'
textures = require 'textures'

template = """
	<svg ng-init='vm.resize()' ng-attr-height='{{vm.height + vm.mar.top + vm.mar.bottom}}'>
		<g class='g-main' shifter='{{::[vm.mar.left, vm.mar.top]}}'>
			<path class='road' stroke-linejoin="round"  stroke='{{vm.texture.url()}}' ng-attr-d='{{vm.lineFun(vm.road_data)}}z'/>
			<path class='stripe' ng-attr-d='{{vm.lineFun(vm.road_data)}}z'/>
			<g class='g-stops'>
				<g ng-repeat='stop in vm.stops' ng-attr-transform='{{vm.place_stop(stop)}}'>
					<g stop-der=stop></g>
				</g>
			</g>
			<g class='g-buses'>
				<g ng-repeat='bus in vm.buses' ng-attr-transform='{{vm.place_bus(bus)}}' bus-der data=bus></g>
			</g>
		</g>
	</svg>
"""
class MapCtrl
	constructor: (@scope, @element, @window) ->
		@mar = {left: 60, right: 60, top: 60, bottom: 60}
		@aspectRatio = .52
		@buses = Data.buses
		@stops = Data.stops
		@road = d3.select @element[0]
			.select 'path.road'
			.node()

		@texture = textures
			.paths()
		    .d "woven"
		    .size 1.7
		    .strokeWidth .7
		    .stroke '#514A53'

		d3.select @element[0]
			.select 'svg'
			.call @texture

		@Y = d3.scale.linear().domain [0,100]
		@X = @Y.copy()
		@road_data = [ [54, 100], [54, 50], [100, 50], [100, 0], [0, 0], [0,100]].map (d)-> {x: d[0], y: d[1]}

		@lineFun = d3.svg.line()
			.x (d)-> @X d.x
			.y (d)-> @Y d.y

		angular.element @window 
			.on 'resize' , ()=> @resize()

	mouseover: (event)->
		h = angular.element(@element[0])[0]
			.getBoundingClientRect()
		g = event.target.getBoundingClientRect()
		d3.select(@element[0])
			.select '#test'
			.style
				left: g.left - h.left
				top: g.top - h.top

	resize: ()->
		@width = @element[0].clientWidth - @mar.left - @mar.right
		@height = @width * @aspectRatio
		@road_length = @road.getTotalLength()
		@Y.range [@height, 0]
		@X.range [0, @width]
		@scope.$evalAsync()

	place_bus: (d)->
		percent = d.location / World.road_length
		road_length = @road.getTotalLength()
		p0 = @road.getPointAtLength percent*road_length
		p = @road.getPointAtLength (percent+.005)%1*road_length
		angle = 180/Math.PI * Math.atan2 p.y - p0.y, p.x - p0.x 
		"translate( #{p0.x} , #{p0.y} ) rotate( #{angle} )"
		
	place_stop: (d)->
		road_length = @road.getTotalLength()
		percent = d.location / World.road_length
		p = @road.getPointAtLength percent*road_length
		p0 = @road.getPointAtLength (percent+.001)%1*road_length
		angle = -Math.atan2 p.y - p0.y , p.x - p0.x
		x = p.x+ 30*Math.sin angle
		y = p.y + 30*Math.cos angle
		"translate(#{x},#{y})"

der = ()->
	directive = 
		template: template
		controller: ['$scope','$element','$window', MapCtrl]
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		link: (scope, el, attr)->
			d3.select(el[0])
				.select '.road'
		scope: {}

module.exports = der
