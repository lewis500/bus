controller = ($scope, $element, $window) ->
	@mar = {left: 40, top: 20, right: 20, bottom: 30}
	@yScale = d3.scale.linear().domain([0, World.num_cars])
	@xScale = d3.scale.linear().domain([0, World.num_minutes])
	@yAxis = d3.svg.axis().ticks(10).scale(@yScale).orient("left")
	@xAxis = d3.svg.axis().ticks(10).scale(@XScale).orient("bottom")
	@arr_line = d3.svg.line()
		.y((d)=> @yScale(d.cum_arr))
		.x((d)=> @xScale(d.time))
	@exit_line = d3.svg.line()
		.y((d)=> @yScale(d.cum_exits))
		.x((d)=> @xScale(d.time))
	aspectRatio = .7
	@shift = 'transform(#{@mar.left},#{@mar.top})'
	element($window).on 'resize' , ()=>
		@width = $element[0].clientWidth - @mar.left - @mar.right
		@height = @width * .7
		@yScale.range([@height, 0])
		@xScale.range([0, @width])
		$scope.$evalAsync()