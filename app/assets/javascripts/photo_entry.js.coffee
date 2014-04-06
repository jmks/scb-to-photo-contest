jQuery ->
  $("#s3-uploader").S3Uploader()

  $('.photo-panel').on 'click', ->
    $this = $(this)
    if $this.hasClass 'clicked'
      $this.removeClass 'clicked'
    else
      $('.photo-panel').removeClass 'clicked'
      $this.addClass 'clicked'