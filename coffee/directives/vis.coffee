Settings = require '../services/settings'
element = require('angular').element
World = require '../services/world'

der = ()->

	controller = ($scope, $element, $window) ->
		@mar = 20
		aspectRatio = .7
		@buses = World.buses
		@paxes = World.pax
		@stops = World.stops
		@road_width = 20
		@car_height = 6
		@shift = ()=>'translate(' + [@radius + @mar, @radius + @mar] + ')'
		@rotator = (d)-> 'rotate(' + (d.location / Settings.road_length * 360) + ')'
		@resize = ()=>
			@height = $element[0].clientWidth
			@radius = @height/2 - @mar - @road_width/2
			$scope.$evalAsync()

		element($window).on('resize' , @resize)

	template = """
		<svg width='100%' ng-attr-height='{{vm.height}}' ng-init='vm.resize()'>
			<g class='g-main' ng-attr-transform='{{vm.shift()}}'>
				<circle class='road' ng-attr-r='{{vm.radius}}' ng-attr-stroke-width='{{::vm.road_width}}'></circle>
				<g class='g-buses'>
					<g ng-repeat='bus in vm.buses' ng-attr-transform='{{vm.rotator(bus)}}'>
						<rect class='bus-rect' ng-attr-y='{{vm.radius - vm.car_height/2 }}' rx='2' ry='2' width='10' ng-attr-height='{{vm.car_height}}'></rect>
					</g>
				</g>
				<g class='g-stops'>
					<g ng-repeat='stop in vm.stops' ng-attr-transform='{{vm.rotator(stop)}} translate(0, {{vm.radius - vm.road_width}})'>
						<rect class='stop-rect' rx='2' ry='2' width='10' height='10' x='-5'></rect>
						<g class='g-pax'>
							<circle ng-repeat='pax in stop.queue' r='3' ng-attr-cy='{{-$index * 6}}' cx='-3'></circle>
						</g>
					</g>
				</g>
			</g>
		</svg>
	"""

	directive = 
		template: template
		controller: controller
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		scope: {}

module.exports = der
