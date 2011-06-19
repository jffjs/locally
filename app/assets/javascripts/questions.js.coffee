# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	map = window.map # get the map object
	
	$('#ask-question-link').click ->
		href = $(this).attr('href')
		href = href + "?coords=#{map.getCenter().lat()},#{map.getCenter().lng()}"
		$(this).attr('href', href)