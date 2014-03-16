$(document).on 'page:change', ->
  $('li.judge').popover({ 
    container: 'body',
    html: true,
    content: $(this).find('.judge-bio').html()
  });

  $('a#mail-us').click (e) ->
    $('#mail-us-modal').modal('show');
    e.preventDefault();

  $('#home-welcome').backstretch '/assets/scarborough_bluffs_bg.jpg'