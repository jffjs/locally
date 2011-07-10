# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$("#places-list ul").click ->
		#ref = $(this).val() # this isn't working yet, elements don't exist when this code is run
		alert("Hello")
		#$("#selected-place #place_ref").val(ref)