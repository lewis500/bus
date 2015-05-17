World = require '../services/world'

template = '''
	<circle class='stop' ng-attr-r='{{vm.radius}}' ></circle>
	<text class='bus-icon' y ='-2'>
		&#xf207;
	</text>
	<text class='bus-label' y='8'>STOP</text>
	<g class='g-pax'></g>
'''

controller = (@scope, @element)->
			@radius = 22
			@queue = @data.boarding_paxes
			el = angular.element( @element[0])[0]
			d3.select @element[0]
				.on 'mouseover' , =>
					@data.show = true
					@scope.$evalAsync()
				.on 'mouseleave', =>
					@data.show = false
					@scope.$evalAsync()
					
			resizer = =>
					@data.loc = el.getBoundingClientRect()
			resizer()
			angular.element window
				.on 'resize' , resizer

der = ()->
	directive = 
		template: template
		controllerAs: 'vm'
		templateNamespace: 'svg'
		bindToController: true
		scope: 
			data: '=stopDer'
		controller: ['$scope', '$element', controller]
		link: (scope, el, attr, vm)->
			sel = d3.select el[0]
				.attr 'class', 'stop-'+vm.data.n
			g = sel.select 'g.g-pax'

			update = (newVal, oldVal)->
				circles = g.selectAll 'circle.pax'
					.data vm.queue, (d)-> d.id

				circ = 84
				norm_len = 16
				space = circ/norm_len
				pax_rad = Math.min(space, 80/vm.queue.length)*.8/2

				circles
					.transition 'place'
					.duration 180 * World.scale
					.delay (d,i)-> 
						((i+1)**1.2)*20
					.ease 'cubic'
					.attr
						transform: (d,i)->
							angle = i / Math.max(norm_len, vm.queue.length) * 360 
							"rotate( #{ angle } )"
						r: pax_rad

				circles.enter()
					.append 'circle'
					.attr
						r: 0
						cy: 15
						transform: (d,i)->
							angle = (vm.queue.length-1) / Math.max(norm_len, vm.queue.length) * 360 
							"rotate( #{ angle } )"
						class: (d,i)->'pax stop-' + d.destination.n
					.transition 'grow'
					.ease 'cubic-out'
					.delay ((vm.queue.length+1)**1.2)*20 * World.scale
					.duration 150 * World.scale
					.attr 'r' , pax_rad*1.2
					.transition 'snapback'
					.duration 50 * World.scale
					.ease 'cubic'
					.attr 'r', pax_rad

				circles.exit()
					.transition('grow2leave')
					.duration 50 * World.scale
					.ease 'cubic-out'
					.attr 'r', pax_rad*1.2
					.transition('leave')
					.duration 70 * World.scale
					.ease 'cubic'
					.attr 'r', 0 
					.remove()

			scope.$watch 'vm.queue.length', update


module.exports = der