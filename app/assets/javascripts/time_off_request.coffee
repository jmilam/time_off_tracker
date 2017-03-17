$(document).on "turbolinks:load", ->
	months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	$('#start_date').datepicker
    dateFormat: 'yy-mm-dd'
  
  $('#end_date').datepicker
    dateFormat: 'yy-mm-dd'
    onClose: (start_date, end_date) -> 
    	start_date = $('#start_date').datepicker 'getDate'
    	end_date = $(this).datepicker 'getDate'
    	start_date = months[start_date.getMonth()] + " " + start_date.getDate() +  "," + start_date.getFullYear()
    	end_date = months[end_date.getMonth()] + " " + end_date.getDate() +  "," + end_date.getFullYear()
    	if start_date == end_date
    		console.log 'They match'
    		$('#total_hours').removeClass 'hide'
    	else
    	  console.log 'Try again'

 	