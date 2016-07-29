# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
createPicker=()->
  view = new google.picker.DocsView(google.picker.ViewId.FOLDERS)
  view.setSelectFolderEnabled(true)
  view.setMimeTypes('application/vnd.google-apps.folder')
  picker = new google.picker.PickerBuilder().addView(view).
       setOrigin(window.location.protocol + '//' + window.location.host).
       setOAuthToken($('#display-form-info').data("token")).
       setDeveloperKey($('#display-form-info').data("key")).
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
   $('#display_google_folder_id').val(file_id)
   $('#name-display').text(file_name)
   $('#name-display').attr('href',file_url)
   $('#display_google_account_id').val($('#display-form-info').data("id"))

$(document).ready ->
  $(document).on('click','#display-select-btn',(event)->
    event.preventDefault();
    createPicker();
  )

$(document).on "page:change", ->
  return unless $(".displays.show").length > 0
  $('.slider').slider({full_width: true})
  root = exports ? this
  root.grid=$('.display-grid').isotope({
    layoutMode: 'packery'
  })
  root.grid.imagesLoaded().progress(->
    root.grid.isotope('layout')
  )
