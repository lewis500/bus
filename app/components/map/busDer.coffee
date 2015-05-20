_ = require 'lodash'
World = require '../../services/world'

template = '''
	<g class='g-bus' transform='translate(-15, 0)'>
		<g class='g-grow'>
			<rect class='bus' rx='2' ry='2' width='34px' height='14px' y='-7' x='-17px'></rect>
			<g class='g-pax' transform='translate(-19,-2.3)'></g>
		</g>
	</g>
'''

der = ()->
	directive = 
		template: template
		scope: 
			bus: '='
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		controller: ()->
			@queue = @bus.queue
		link: (scope, el, attr, vm)->
			sel = d3. select el[0]
			gGrow = sel.select '.g-grow'
			rect = sel.select 'rect.bus'
				.attr 'fill' , 'black'
			gPax = sel.select 'g.g-pax'

			scope.$watch 'vm.bus.hilited', (v)->
				if v
					rect.transition()
						.duration 345
						.ease 'bounce-in'
						.attr 'stroke-width', 5.5
						.transition('something')
						.duration 130
						.ease 'cubic'
						.attr 'stroke-width', 2

				else 
					rect.transition()
						.duration 175
						.ease 'cubic'
						.attr 'stroke-width', 0

			scope.$watch 'vm.bus.held', (v)->
				if v
					rect.transition 'grow'
						.duration 200
						.ease 'bounce-in'
						.attr 'transform', 'scale(1.1)'
						.transition()
						.ease 'cubic'
						.duration 100
						.attr 'transform', 'scale(1)'

					rect.transition 'color'
						.duration 100
						.ease 'cubic'
						.attr 'fill', 'white'
				else 
					rect.transition 'hold'
						.duration 175
						.ease 'cubic'
						.attr 'fill', 'black'

			scope.$watch 'vm.bus.docked' , (v)->
				if v
					gGrow.transition 'grow'
						.duration 200
						.delay 125
						.ease 'cubic-out'
						.attr 'transform', 'scale(1.11)'
						.transition()
						.ease 'cubic'
						.duration 100
						.attr 'transform', 'scale(1.05)'

					gGrow.transition 'color'
						.duration 100
						.ease 'cubic'
						.attr 'fill', 'white'
				else 
					gGrow.transition 'hold'
						.duration 175
						.ease 'cubic'
						.attr 'transform', 'scale(1)'

			places = []

			[0..Math.floor(World.max_capacity/2)]
				.forEach (row)->
						[0...2].forEach (col)->
							places.push 
								row: row
								col: col
								filled: false

			update = (newVal, oldVal)->
				circles = gPax.selectAll 'circle.pax'
					.data vm.bus.queue, (d)-> d.id

				circles.enter()
					.append 'circle'
					.attr
						r: 0
						transform: (d,i)->
							spot = _.find places, (v)-> !v.filled 
							d.spot = spot
							spot.filled = true
							x =  30 - spot.row * 3
							y = spot.col * 5
							"translate( #{x}, #{y} )"
						class: (d,i)->'pax stop-' + d.destination.n
					.transition 'grow'
					.ease 'cubic-out'
					.delay 10
					.duration 180 
					.attr 'r' , 1.8 
					.transition 'shrink'
					.duration 90 
					.ease 'cubic'
					.attr 'r', 1.3

				circles.exit()
					.transition 'leave'
					.duration 80 
					.ease 'cubic'
					.attr 'r', 0
					.each 'end' , (d)->
						d.spot.filled = false
						d3.select(this).remove()

			scope.$watch 'vm.queue.length', update

module.exports = der