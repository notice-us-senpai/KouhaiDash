# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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
