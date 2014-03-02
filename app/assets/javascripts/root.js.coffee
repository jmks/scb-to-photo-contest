$(document).on 'page:change', ->
  $('li.judge').popover({ 
    container: 'body',
    html: true,
    content: $(this).find('.judge-bio').html()
  });