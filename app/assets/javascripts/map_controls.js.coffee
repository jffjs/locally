# Set up behavior for the map controls

$ ->
	map = window.map
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