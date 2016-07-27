# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).on('change input','.memberships-search', ( ->
    $('#memberships_search_form').submit()
  ))
$(document).on "page:change", ->
  return unless $(".memberships.index").length > 0
  grid=$('.grid').isotope({
    itemSelector: '.grid-item',
    percentPosition: true
  })
  grid.imagesLoaded().progress( (->
    grid.isotope('layout')
  ))
