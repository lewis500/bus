'use strict'

angular = require 'angular'
mainDer = require './components/main/mainDer'
mapDer = require './components/map/mapDer'
busDer = require './components/map/busDer'
shifter = require './directives/shifter'
stopDer = require './directives/stopDer'


app = angular.module('mainApp', [])
	.directive 'mainDer', mainDer
	.directive 'mapDer', mapDer
	.directive 'shifter', shifter
	.directive 'stopDer', stopDer
	.directive 'busDer', busDer