angular = require 'angular'
World = require '../../services/world'
Data = require '../../services/data'
textures = require 'textures'
_ = require 'lodash'
# template = """
# 	<svg ng-attr-height='{{vm.height}}'>
# 		<g class='g-main'>
# 			<path class='road' stroke-linejoin="round"  stroke='{{vm.texture.url()}}' ng-attr-d='{{vm.lineFun(vm.road_data)}}z'/>
# 			<g class='g-buses'>
# 				<g ng-repeat='bus in vm.buses' ng-attr-transform='{{vm.place_bus(bus)}}' bus-der data=bus></g>
# 			</g>
# 		</g>
# 	</svg>
# """
			# <g class='g-stops'>
			# 	<g ng-repeat='stop in vm.stops' ng-attr-transform='{{vm.place_stop(stop)}}'>
			# 		<g stop-der=stop></g>
			# 	</g>
			# </g>
			# <path class='stripe' ng-attr-d='{{vm.lineFun(vm.road_data)}}z'/>

class MapCtrl
	constructor: (@scope, @element, @window) ->
		sel =  d3.select @element[0]
		@road = sel.select 'path.target_road'
			.node()

		@CH = sel.node().clientHeight
		@CW = sel.node().clientWidth
		@aspectRatio = @CH/@CW

		@buses = Data.buses
		@stops = Data.stops


		@aspectRatio = 760.76667/747.0819

		angular.element @window 
			.on 'resize' , ()=> @resize()

	resize: ()->
		@width = @element[0].clientWidth
		@height = @width * @aspectRatio
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
		templateUrl: './styles/picture.svg'
		controller: ['$scope','$element','$window', MapCtrl]
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		scope: {}

module.exports = der
