# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

  $(document).on('click','.assignremovebtn', ( ->
    if $(this).data("preexisting")
      $(this).parent().hide()
      $("#task_task_assignments_attributes_"+$(this).data("id")+"__destroy").val("true")
    else
      $(this).parent().remove()
  ))
  $(document).on('click','.assignaddbtn',(->
    milliseconds = (new Date).getTime()
    $('#assign_list').append("<li>
      <label for='membership_id'>User:</label>
      <select name='task[task_assignments_attributes]["+milliseconds+"][membership_id]' id='task_task_assignments_attributes_"+milliseconds+"_membership_id'>
      "+$('#assign_select_template').html()+"
      </select>
      <button type='button' class='assignremovebtn' data-preexisting='false' data-id='"+milliseconds+"'>Remove</button>
      </li>"
    )
  ))
