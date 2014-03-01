# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:change', ->
  $('#new-comment-btn').click(-> 
    $(this).hide().closest('#new-comment-wrapper').find('.new-comment').show()
  )

  $('.datepicker').datepicker({});