# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('.delete-photo-link').click (evt) ->
    evt.preventDefault()
    title = $(this).closest('tr').find('.photo-title').html()
    modal$ = $('#confirm-delete-modal')
    modal$.find('.photo-title').html(title)
    modal$.find('#delete-photo-confirmation').prop('href', $(this).attr('href'))
    modal$.modal('show')
    false