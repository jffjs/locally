$ ->
	mapOptions = { zoom: 11, mapTypeId: google.maps.MapTypeId.ROADMAP }
	# Set the map to a window property so we can access it globally
	map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
	
	if $('#coords').size() > 0
		coordsArray = $('#coords').val().split(' ')
		location = new google.maps.LatLng(coordsArray[0], coordsArray[1])
		map.setCenter(location)
	else
		geoLocate()
		
	#setMapControls(map)
	searchControl = $('#map-search').get(0)
	map.controls[google.maps.ControlPosition.TOP_LEFT].push(searchControl)
	
	geoLocate = ->
		initialLocation
		browserSupportFlag = false		
		# Try W3C Geolocation (Preferred)
		if navigator.geolocation
			browserSupportFlag = true
			navigator.geolocation.getCurrentPosition (position) ->
				initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude)
				map.setCenter(initialLocation)
			, ->
				handleNoGeolocation(browserSupportFlag)
		# Try Google Gears Geolocation
		else if google.gears
			browserSupportFlag = true
			geo = google.gears.factory.create('beta.geolocation')
			geo.getCurrentPosition (position) ->
				initialLocation = new google.maps.LatLng(position.latitude,position.longitude)
				map.setCenter(initialLocation)
			, ->
				handleNoGeoLocation(browserSupportFlag)
		# Browser doesn't support Geolocation
		else
			handleNoGeolocation(browserSupportFlag)
			
		handleNoGeolocation = (errorFlag) ->
			# map.setCenter(initialLocation)
	    
		$.get('/questions', { new_coords: map.center.lat() + ',' + map.center.lng() })
	
	#setMapControls = (map) ->
		#searchControl = $('#map-search').get(0)
		#map.controls[google.maps.ControlPosition.TOP_LEFT].push(searchControl)
	
	locSearchInitialFocus = true
	$('#map-search-input').focus ->
		if locSearchInitialFocus
			$(this).val('')
			locSearchInitialFocus = false

	$('#map-search form').submit ->
		geoCode($('#map-search-input').val())

	$('#new_question').submit ->
		coord = "#{map.getCenter().lat()},#{map.getCenter().lng()}"
		$('#question_coords').val(coord)

	geoCode = (location) ->
		geocoder = new google.maps.Geocoder()
		geocoder.geocode { 'address': location}, (results, status) ->
			if status == google.maps.GeocoderStatus.OK
				map.setCenter(results[0].geometry.location)