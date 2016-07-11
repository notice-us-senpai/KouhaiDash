# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:change", ->
  return unless $(".categories.index").length > 0
  #stop excecution if not .categories.index
  el = document.getElementById('categories-items')
  sortable = Sortable.create(el,{animation: 150,handle: ".handle", dataIdAttr: 'data-order'})
  sortable.option('onUpdate',(evt)->
    order=sortable.toArray()
    $('#order-form').append("<input type='hidden' name='category[order_no][]' value='"+order[i]+"'>") for i in [0..order.length-1]
    $('#order-form').submit()
    $('#order-form').empty()
  )
