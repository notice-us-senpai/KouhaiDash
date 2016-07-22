# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:change", ->
  return unless $(".events:not(.show,.index)").length > 0
  $('.datepicker').pickadate({
    selectMonths: true, #Creates a dropdown to control month
    selectYears: 11 #Creates a dropdown of 11 years to control year
  })
  $('.datepicker').pickadate({
    selectMonths: true, #Creates a dropdown to control month
    selectYears: 11 #Creates a dropdown of 11 years to control year
  })
