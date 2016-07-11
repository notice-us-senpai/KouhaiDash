# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery.expr[':'].icontains = jQuery.expr.createPseudo((arg) ->
  (elem) ->
    jQuery(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0
)
taskFilter = () ->
  from=Date.parse($('#task-from-date-field').val()+" 00:00:00 UTC")
  till=Date.parse($('#task-till-date-field').val()+" 00:00:00 UTC")
  $('.card:not(:icontains('+$('#task-search-field').val()+'))').hide('fast')
  $('.card:icontains('+$('#task-search-field').val()+')').each((index)->
    deadline=parseInt($(this).data('deadline'))
    if !isNaN(from) && deadline<from
      $(this).hide('fast')
      return
    if !isNaN(till) && deadline>till
      $(this).hide('fast')
      return
    if ($('#task-done-field')[0].checked && $(this).data('done')) || ($('#task-not-done-field')[0].checked && !$(this).data('done'))
      $(this).show('fast')
    else
      $(this).hide('fast')
  )

$(document).ready ->

  $(document).on('click','.assignremovebtn', ( ->
    id = $(this).data("id")
    if $(this).data("preexisting")
      $("*[data-id=" + id + "]").hide()
      $("#task_task_assignments_attributes_"+$(this).data("id")+"__destroy").val("true")
    else
      $("*[data-id=" + id + "]").remove()
  ))
  $(document).on('click','.assignaddbtn',(->
    milliseconds = (new Date).getTime()
    $('#assign_list').append("
      <tr data-id="+milliseconds+">
        <td>
          <select name='task[task_assignments_attributes]["+milliseconds+"][membership_id]' id='task_task_assignments_attributes_"+milliseconds+"_membership_id'>
          "+$('#assign_select_template').html()+"
          </select>
        </td>
        <td>
          <button type='button' class='assignremovebtn btn' data-preexisting='false' data-id='"+milliseconds+"'>Remove</button>
        </td>
      </tr>"
    )
    $('select').material_select()
  ))
  $(document).on('click','.task-filter-btn',(->
    taskFilter()
  ))
  $(document).on('input','.task-filter-field',(->
    taskFilter()
  ))
  $(document).on('change','.task-filter-field',(->
    taskFilter()
  ))
  $(document).on('click','#task-reset-btn',(->
    $('.task-filter-field').val("")
    $('.task-filter-btn').prop('checked', true)
    taskFilter()
  ))

$(document).on "page:change", ->
  return unless $(".tasks:not(.show,.index)").length > 0
  $('.datepicker').pickadate({
   selectMonths: true, #Creates a dropdown to control month
   selectYears: 21 #Creates a dropdown of 21 years to control year
 })

$(document).on "page:change", ->
  return unless $(".tasks.index").length > 0
  $('.datepicker').pickadate({
    container: '#datepicker-container',
    selectMonths: true, #Creates a dropdown to control month
    selectYears: 21 #Creates a dropdown of 21 years to control year
  })
  $('.modal-trigger').leanModal()
