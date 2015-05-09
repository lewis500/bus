_ = require 'lodash'
plotCtrl = require '../../services/plotCtrl'
World = require '../../services/world'
d3 = require 'd3'
Data = require '../../services/data'

template = '''
	<svg ng-init='vm.resize()' width='100%' ng-attr-height='{{vm.height + vm.mar.top + vm.mar.bottom}}'>
		<defs>
			<clippath id='{{::vm.ID}}'>
				<rect ng-attr-width='{{vm.width}}' ng-attr-height='{{vm.height}}'></rect>
			</clippath>
		</defs>
		<g class='boilerplate' shifter='{{[vm.mar.left, vm.mar.top]}}'>
			<rect class='background' ng-attr-width='{{vm.width}}' ng-attr-height='{{vm.height}}'></rect>
			<g y-axis scale='vm.Y' width='vm.width'></g>
			<g ex-axis scale='vm.X' height='vm.height' shifter='{{[0,vm.height]}}'></g>
		</g>
		<g class='main' clip-path="url(#{{::vm.ID}})" shifter='{{::[vm.mar.left, vm.mar.top]}}'>
			<path class='cumulative' line-der watch='vm.watch' data='vm.data' line-fun='vm.lineFun'></path>
		</g>
	</svg>
'''

class cumCtrl extends plotCtrl
	constructor: (@scope, @element)->
		super(@scope, @element)

		@data = Data.stops[0].history

		@lineFun = d3.svg.area()
			.y1 (d)=> @Y(d.count)
			.y0 (d)=> @Y(0)
			.x (d)=> @X(World.max_history - (World.time - d.time)/1000)

		@ID = _.uniqueId 'chart'

		@X.domain([0,World.max_history+10])

		@scope.$watch(()=> 
						@data.slice(-1)[0]?.time + @data.length
					, ()=>
						max = d3.max @data, (d)-> 
							d.count
						@Y.domain([0, Math.max(5, max * 1.2) ]))

	watch: (data)-> data[data.length-1]?.time + data.length

der = ()->
	directive = 
		controllerAs: 'vm'
		scope: {} # data: '=stop'
		template: template
		bindToController: true
		templateNamespace: 'svg'
		controller: ['$scope','$element', cumCtrl]

module.exports = der
