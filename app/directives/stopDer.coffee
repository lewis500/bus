Settings = require '../services/settings'

template = '''
	<circle class='stop' ng-attr-r='{{vm.radius}}'></circle>
	<text class='bus-icon'>
		&#xf207;
	</text>
	</foreignObject>
	<g class='g-pax'></g>
'''
der = ()->
	directive = 
		template: template
		controllerAs: 'vm'
		bindToController: true
		scope: 
			data: '=stopDer'
		controller: ()->
			@radius = 20
			@queue = @data.boarding_paxes
		link: (scope, el, attr, vm)->
			g = d3.select(el[0]).select('g.g-pax')

			d3.select(el[0]).attr 'class', 'stop-'+ vm.data.n

			update = (newVal, oldVal)->
				circles = g.selectAll 'circle.pax'
					.data vm.queue, (d)-> d.id

				circ = 80
				norm_len = 16
				space = circ/norm_len
				pax_rad = Math.min(space, 80/vm.queue.length)*.8/2

				circles
					.transition 'place'
					.duration 180 * Settings.scale
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
						cy: 12.7
						transform: (d,i)->
							angle = (vm.queue.length-1) / Math.max(norm_len, vm.queue.length) * 360 
							"rotate( #{ angle } )"
						class: (d,i)->'pax stop-' + d.destination.n
					.transition 'grow'
					.ease 'cubic-out'
					.delay ((vm.queue.length+1)**1.2)*20 * Settings.scale
					.duration 150 * Settings.scale
					.attr 'r' , pax_rad*1.2
					.transition 'snapback'
					.duration 50 * Settings.scale
					.ease 'cubic'
					.attr 'r', pax_rad

				circles.exit()
					.transition('grow2leave')
					.duration 50 * Settings.scale
					.ease 'cubic-out'
					.attr 'r', pax_rad*1.2
					.transition('leave')
					.duration 70 * Settings.scale
					.ease 'cubic'
					.attr 'r', 0 
					.remove()

			scope.$watch 'vm.queue.length', update


module.exports = der