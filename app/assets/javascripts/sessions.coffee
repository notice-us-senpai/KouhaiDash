# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).on('click','#google-register-toggle', ( ->
    $('.google-register-form').toggle()
    $('.google-login-form').toggle()
    if $('.google-login-form').is(':visible')
      $(this).html('Register a new account')
    else
      $(this).html('Or log in with existing account')
  ))

  #page title scroll
  $(document).on('click',"#page-title", ( ->
    $('html, body').animate({ scrollTop: 0 }, 'fast')
  ))
