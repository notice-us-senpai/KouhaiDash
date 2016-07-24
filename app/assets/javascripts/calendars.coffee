# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).on('change','.calendar_radio', ( ->
    $('#google_calendar_id').prop('disabled',$('#gradio_select').prop('checked')==false)
    $('#google_name').prop('disabled',$('#gradio_new').prop('checked')==false)
    $('select').material_select()
  ))
  $(document).on('change','.calendar-period', ( ->
    $('#calendar_period_form').submit()
  ))

$(document).on "page:change", ->
  return unless $(".calendars.new, .calendars.edit, .calendars.update, .calendars.create").length > 0
  $('#google_calendar_id, #google_name').prop('disabled',true)


$(document).on "page:change", ->
  return unless $(".calendars.show").length > 0
  $('.modal-trigger').leanModal()
