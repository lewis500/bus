d3 = require('d3')
element = require('angular').element
World = require './World.coffee'

module.exports.controller = ($scope, $element, $window) ->
	mar = @mar = {left: 80, top: 20, right: 20, bottom: 30}
	@yScale = d3.scale.linear().domain([0, World.num_cars])
	@xScale = d3.scale.linear().domain([0, World.num_minutes])
	@yAxis = d3.svg.axis().ticks(10).scale(@yScale).orient("left")
	@xAxis = d3.svg.axis().ticks(10).scale(@xScale).orient("bottom")
	@arr_line = d3.svg.line()
		.y((d)=> @yScale(d.cum_arrivals))
		.x((d)=> @xScale(d.time))
	@exit_line = d3.svg.line()
		.y((d)=> @yScale(d.cum_exits))
		.x((d)=> @xScale(d.time))
	aspectRatio = .7
	@shift = ()->'translate(' + [mar.left,mar.top] + ')'
	@resize = ()=>
		@width = $element[0].clientWidth - @mar.left - @mar.right
		@height = @width * .7
		@yScale.range([@height, 0])
		@xScale.range([0, @width])
		$scope.$evalAsync()

	element($window).on('resize' , @resize)

module.exports.directive = ()->

	template = """
		<svg width='100%' ng-attr-height='{{vm.height + vm.mar.top + vm.mar.bottom}}' ng-init='vm.resize()'>
			<g class='g-main' ng-attr-transform='{{::vm.shift()}}'>
				<g class='y-axis axis'></g>
				<g class='x-axis axis' ng-attr-transform='translate(0,{{vm.height}})'></g>
				<g class='g-lines'>
					<path class='arr-line'></path>
					<path class='exit-line'></path>
				</g>
			</g>
		</svg>
	"""

	link = (scope, el, attr, vm)->
		svg = d3.select(el[0]).select('svg')
		arrLine = svg.selectAll('path.arr-line')
		exitLine = svg.selectAll('path.exit-line')
		yAxis = svg.selectAll 'g.y-axis'
		xAxis = svg.selectAll 'g.x-axis'

		toWatch = ()-> vm.yScale.range()[0] + vm.xScale.range()[1]

		toWatch2 = ()-> vm.data[100].cum_arrivals + vm.data[100].cum_exits

		update2 = ()-> 
			arrLine.attr 'd', vm.arr_line(vm.data)
			exitLine.attr 'd', vm.exit_line(vm.data)

		update = ()->
			yAxis.call vm.yAxis
			xAxis.call vm.xAxis
			update2()

		scope.$watch(toWatch, update)
		scope.$watch(toWatch2, update2)

	directive = 
		link: link
		template: template
		controller: 'lineChartCtrl'
		restrict: 'A'
		bindToController: true
		controllerAs: 'vm'
		templateNamespace: 'svg'
		scope: {data: '='}
