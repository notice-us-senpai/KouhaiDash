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

  $(document).on('click','.display-toggle',->
    if $(this).parent().height()>=$(this).parent().width()
      $(this).parent().toggleClass('display-tall')
    else
      $(this).parent().toggleClass('display-wide')
    $(this).css('transform','')
    $(this).width('')
    $(this).parent().width('')
    $(this).height('')
    $(this).parent().height('')

    $(this).data('full', !($(this).data('full')) )

    $(this).imagesLoaded().always( (instance)->
      images= instance.images
      for image in images
        img= $(image.img)
        parent=img.parent()
        if img.data('full')
          img.addClass('full display-rotate-'+img.data('rotation'))
          if img.hasClass('display-rotate-1') && parent.hasClass('display-tall')
            img.width('80vh')
            img.height('auto')
            parent.width(img.height())
            parent.height(img.width())
          if img.hasClass('display-rotate-1') && parent.hasClass('display-wide')
            img.width('auto')
            img.height(parent.parent().width())
            parent.width(img.height())
            parent.height(img.width())
        else
          img.removeClass('full display-rotate-'+img.data('rotation'))

        grid=$('.display-grid').isotope({
          layoutMode: 'packery',
          itemSelector: '.display-grid-item',
          packery: {
            gutter: 0
          }
        })
        grid.on( 'layoutComplete', ->
          $('.display-wide .display-rotate-1').each(->
            displace=parseInt(-0.5*parseFloat($(this).parent().width()) + 0.5*parseFloat($(this).parent().height()))+'px'
            $(this).css('transform','rotate(90deg) translate('+displace+','+displace+')')
          )
          $('.display-tall .display-rotate-1').each(->
            displace=parseInt(-0.5 * parseFloat($(this).parent().width()) + 0.5 * parseFloat($(this).parent().height()))+'px'
            $(this).css('transform','rotate(90deg) translate('+displace+','+displace+')')
          )
        )
    )
    swap = $(this).attr('src')
    $(this).attr('src',"")
    $(this).attr('src',$(this).data('toggle'))
    $(this).data('toggle',swap)
  )

$(document).on "page:change", ->
  return unless $(".displays.show").length > 0
  $('.slider').slider({full_width: true})
  $('.display-grid-item').width('auto').height('auto')
  root = exports ? this
  root.grid = $('.display-grid').isotope({
    layoutMode: 'packery',
    itemSelector: '.display-grid-item',
    packery: {
      gutter: 0
    }
  })
  root.grid.imagesLoaded().progress(->
    root.grid.isotope('layout')
  )
