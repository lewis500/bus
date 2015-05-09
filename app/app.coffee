'use strict'

angular = require 'angular'
mainDer = require './components/main/mainDer'
mapDer = require './components/map/mapDer'
busDer = require './components/map/busDer'
shifter = require './directives/shifter'
stopDer = require './directives/stopDer'
sliderDer = require './directives/slider'
cumChart = require './components/cumulative/cumChart'
exAxis = require './directives/xAxis'
yAxis = require './directives/yAxis'
lineDer = require './directives/line'

app = angular.module('mainApp', [])
	.directive 'mainDer', mainDer
	.directive 'mapDer', mapDer
	.directive 'shifter', shifter
	.directive 'stopDer', stopDer
	.directive 'busDer', busDer
	.directive 'slider', sliderDer
	.directive 'cumChart' , cumChart
	.directive 'exAxis', exAxis
	.directive 'yAxis' , yAxis
	.directive 'lineDer', lineDer