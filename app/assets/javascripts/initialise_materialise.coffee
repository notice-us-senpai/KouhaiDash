$(document).ready ->
  $(document).on('focus','textarea',(->
    $('textarea').trigger('autoresize')
  ))
$(document).on "page:change", ->
  Waves.displayEffect()
  $('select').material_select()
  $(".button-collapse").sideNav()
  $('.tooltipped').tooltip({delay: 50})
  Materialize.updateTextFields()
  $('.message').hide()
  $('.message').each(->
    Materialize.toast($(this).html(), 4000);
  )
