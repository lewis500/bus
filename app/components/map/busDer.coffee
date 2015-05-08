_ = require 'lodash'
Settings = require '../../services/settings'

template = '''
	<g transform='translate(-32,0)'>
		<rect class='bus' rx='2' ry='2' width='42px' height='16px' y='-8'></rect>
		<g class='g-pax' transform='translate(-2,-3)'></g>
	</g>
'''

der = ()->
	directive = 
		template: template
		scope: 
			data: '='
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		controller: ()->
			@queue = @data.queue
		link: (scope, el, attr, vm)->
			d3.select(el[0]).on 'click', ()-> vm.data.delay()

			g = d3.select(el[0]).select('g.g-pax')

			places = []

			[0..Math.floor(Settings.max_capacity/2)].forEach (row)->
					[0...2].forEach (col)->
						places.push 
							row: row
							col: col
							filled: false

			update = (newVal, oldVal)->
				circles = g.selectAll 'circle.pax'
					.data vm.queue, (d)-> d.id

				circles.enter()
					.append 'circle'
					.attr
						r: 0
						transform: (d,i)->
							spot = _.find places, (v)-> !v.filled 
							d.spot = spot
							spot.filled = true
							x =  40 - spot.row * 3.5
							y = spot.col * 6
							"translate( #{x}, #{y} )"
						class: (d,i)->'pax stop-' + d.destination.n
					.transition 'grow'
					.ease 'cubic-out'
					.delay 10
					.duration 150 * Settings.scale
					.attr 'r' , 2 
					.transition 'snapback'
					.duration 50 * Settings.scale
					.ease 'cubic'
					.attr 'r', 1.5

				circles.exit()
					.transition 'leave'
					.duration 50 * Settings.scale
					.ease 'cubic-out'
					.attr 'r', 2
					.transition()
					.duration 100 * Settings.scale
					.ease 'cubic-in'
					.attr 'r', 0 
					.each (d)-> d.spot.filled = false
					.remove()

			scope.$watch 'vm.queue.length', update

module.exports = der