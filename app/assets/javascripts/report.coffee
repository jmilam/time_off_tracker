$(document).on "turbolinks:load", ->
	$('.report_modal').on 'click', ->
		$('#report_type').val $(this).data('info')

	$('#transaction_report').on 'click', ->
		$('#reportRangeModal').modal 'hide'
		report = $('#report_type').val()
		start_date = $('#start_date').val()
		end_date = $('#end_date').val()
		ajaxReportRequest '/report', start_date, end_date, report
		


  ajaxReportRequest = (url, start_date, end_date, report_type) ->
  	$.ajax
      url: url
      type: 'GET'
      dataType: 'script'
      data: start_date: start_date, end_date: end_date, report: report_type
      success: (response) ->
        return