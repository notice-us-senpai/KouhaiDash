# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(document).on('change input','.groups-search', ( ->
    $('#groups_search_form').submit()
  ))
$(document).on "page:change", ->
  return unless $(".groups.index").length > 0
  $('.card-grid').isotope({
    itemSelector: '.grid-item',
    percentPosition: true
  })
