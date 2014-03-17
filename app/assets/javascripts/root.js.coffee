$(document).on 'page:change', ->

  if ($('#judges-wrapper'))
    $('li.judge').click ->
      name = $(this).find('.judge-name').html()
      bio  = $(this).find('.judge-bio').html()
      modal$ = $('#judge-modal')
      modal$.find('.modal-title').empty().html(name)
      modal$.find('.modal-body').empty().html(bio)
      modal$.modal 'show'

  $('a#mail-us').click (e) ->
    $('#mail-us-modal').modal('show')
    e.preventDefault()

  $('#home-welcome').backstretch '/assets/scarborough_bluffs_bg.jpg'