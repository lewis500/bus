angular = require 'angular'
World = require '../../services/world'
Data = require '../../services/data'

class MapCtrl
	constructor: (@scope, @element, @window) ->
		@mar = {left: 60, right: 60, top: 60, bottom: 60}
		@aspectRatio = .52
		@buses = Data.buses
		@stops = Data.stops
		@road = d3.select(@element[0]).select('path.road').node()
		prevScale = World._scale
		d3.select( @element[0]).select('.g-main')
			.on 'mouseover', ()->
				prevScale = World._scale
				World._scale = .3
			.on 'mouseout', ()->
				World._scale = prevScale
		@Y = d3.scale.linear().domain([0,100])
		@X = d3.scale.linear().domain([0,100])
		@road_data = [ [54, 100], [54, 50], [100, 50], [100, 0], [0, 0], [0,100]].map (d)-> {x: d[0], y: d[1]}

		@lineFun = d3.svg.line()
			.x (d)-> @X(d.x)
			.y (d)-> @Y(d.y)

		angular.element @window 
			.on 'resize' , ()=> @resize()

	resize: ()->
		@width = @element[0].clientWidth - @mar.left - @mar.right
		@height = @width * @aspectRatio
		@road_length = @road.getTotalLength()
		@Y.range([@height, 0])
		@X.range([0, @width])
		@scope.$evalAsync()

	pos2: (datum)->
		percent = (datum.location / World.road_length)
		road_length = @road.getTotalLength()
		p0 = @road.getPointAtLength(percent * road_length)
		p = @road.getPointAtLength((percent+.005)%1 * road_length)
		angle = Math.atan2(p.y - p0.y, p.x - p0.x) * 180 / Math.PI
		'translate(' + [p0.x, p0.y] + ') rotate(' + angle + ')'
		
	positioner: (datum)->
		road_length = @road.getTotalLength()
		percent = (datum.location / World.road_length)
		p = @road.getPointAtLength(percent * road_length)
		p0 = @road.getPointAtLength((percent+.001)%1 * road_length)
		angle = -Math.atan2(p.y - p0.y, p.x - p0.x)
		[p.x + Math.sin(angle) * 30, p.y + Math.cos(angle)*30]

template = """
	<svg width='100%' ng-init='vm.resize()' ng-attr-height='{{vm.height + vm.mar.top + vm.mar.bottom}}'>
		<g class='g-main' shifter='{{::[vm.mar.left, vm.mar.top]}}'>
			<path class='road' stroke-linejoin="round"  ng-attr-d='{{vm.lineFun(vm.road_data)}}z'></path>
			<path class='stripe' stroke-linejoin="round"  ng-attr-d='{{vm.lineFun(vm.road_data)}}z'></path>
			<g class='g-stops'>
				<g ng-repeat='stop in vm.stops' shifter='{{vm.positioner(stop)}}'>
					<g stop-der=stop></g>
				</g>
			</g>
			<g class='g-buses'>
				<g ng-repeat='bus in vm.buses' ng-attr-transform='{{vm.pos2(bus)}}' bus-der data=bus></g>
			</g>
		</g>
	</svg>
"""
# <rect class='bus' rx='2' ry='2' x='-4' y='-2' width='8' height='4'></rect>

der = ($rootScope)->
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
