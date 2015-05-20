World = require '../services/world'

template = '''
	<circle class='stop' r='22' ng-init='vm.resizer()'></circle>
	<text class='bus-icon'>G</text>
	<g class='g-pax'></g>
'''

class stopDerCtrl
	constructor: (@scope, @element)->
			@queue = @stop.boarding_paxes
			@loc = {}
			d3.select @element[0]
				.on 'mouseover' , =>
					@stop.show = true
					@scope.$evalAsync()
				.on 'mouseleave', =>
					@stop.show = false
					@scope.$evalAsync()

			@scope.$watch ()=>
					@element[0].getBoundingClientRect().left
				, (newVal)=>
					@stop.loc = @element[0].getBoundingClientRect()
			
link = (scope, el, attr, vm)->
			sel = d3.select el[0]
				.attr 'class', 'stop-'+vm.stop.n

			g = sel.select 'g.g-pax'

			bigCirc = d3.select el[0]
				.select 'circle.stop'
				.attr 'fill' , '#F7F7F7'

			scope.$watch 'vm.stop.busy', (v)=>
				if v
					bigCirc.transition()
						.duration 180
						.ease 'cubic'
						.attr 'r',25.5
						.attr 'fill' , 'white'
						.transition()
						.duration 130
						.attr 'r', 24

				else 
					bigCirc.transition()
						.duration 200
						.ease 'back'
						.attr 'r', 21
						.transition()
						.duration 125
						.ease 'cubic-out'
						.attr 'r',22
						.attr 'fill' , '#F7F7F7'


			update = (newVal, oldVal)->
				circles = g.selectAll 'circle.pax'
					.data vm.queue, (d)-> d.id

				circ = 84
				norm_len = 16
				space = circ/norm_len
				pax_rad = Math.min(space, 80/vm.queue.length)*.86/2

				circles
					.transition 'place'
					.duration 180 
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
						transform: (pax,i)->
							angle = (vm.queue.length-1) / Math.max(norm_len, vm.queue.length) * 360 
							"rotate( #{ angle } )"
						class: (pax,i)->"pax stop-#{pax.destination.n}"
					.transition 'grow'
					.ease 'cubic-out'
					.delay ((vm.queue.length+1)**1.2)*20 
					.duration 150 
					.attr 'r' , pax_rad*1.2
					.transition 'snapback'
					.duration 50 
					.ease 'cubic'
					.attr 'r', pax_rad

				circles.exit()
					.transition 'grow2leave'
					.duration 50 
					.ease 'cubic-out'
					.attr 'r', pax_rad*1.2
					.transition 'leave'
					.duration 70 
					.ease 'cubic'
					.attr 'r', 0 
					.remove()

			scope.$watch 'vm.queue.length', update

der = ()->
	directive = 
		template: template
		controllerAs: 'vm'
		templateNamespace: 'svg'
		bindToController: true
		scope: 
			stop: '=stopDer'
		controller: ['$scope', '$element', stopDerCtrl]
		link: link

module.exports = der