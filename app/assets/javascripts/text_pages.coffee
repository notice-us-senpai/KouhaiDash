# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
root = exports ? this
root.onApiLoad=()->
  gapi.load('picker')


createPicker=()->
  picker = new google.picker.PickerBuilder().addView(google.picker.ViewId.DOCUMENTS).
       setOrigin(window.location.protocol + '//' + window.location.host).
       setOAuthToken($('#text-page-form-info').data("token")).
       setDeveloperKey($('#text-page-form-info').data("key")).
       setCallback(pickerCallback).
       build()
  picker.setVisible(true)

pickerCallback=(data)->
   file_id = ''
   file_name =''
   file_url=''
   if data[google.picker.Response.ACTION] == google.picker.Action.PICKED
     doc = data[google.picker.Response.DOCUMENTS][0]
     file_id = doc[google.picker.Document.ID]
     file_name = doc[google.picker.Document.NAME]
     file_url = doc[google.picker.Document.URL]
   $('#text_page_file_id').val(file_id)
   $('#name-display').text(file_name)
   $('#name-display').attr('href',file_url)
   $('#text_page_google_account_id').val($('#text-page-form-info').data("id"))

$(document).ready ->
  $(document).on('click','#text-page-select-btn',(event)->
    event.preventDefault();
    createPicker();
  )

$(document).on "page:change", ->
  return unless $(".text_pages:not(.show)").length > 0
  $('.wysiwyg').froalaEditor()
$(document).on "page:change", ->
  return unless $(".text_pages.show").length > 0
  img = document.getElementById("contents").getElementsByTagName("img")
  for i in [0..img.length-1]
    img[i].style.height= "auto"
    img[i].className = "responsive-img"
    img[i].parentElement.style=""
