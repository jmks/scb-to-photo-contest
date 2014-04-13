// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.backstretch
//= require jquery-scrollto
//= require jquery.jscroll.min
//= require bootstrap
//= require turbolinks
//= require s3_direct_upload
//= require select2
//= require_tree .

$(function() {
  if (!Modernizr.svg) {
    $('img[src$=".svg"]').each(function() {
    $(this).attr('src', $(this).data('fallback'));
    });
  }

  $('#mail-us-modal #send-mail').on('click', function(evt) {
    var message$ = $('#mail-us-modal #mail-message'),
        email$   = $('#mail-us-modal #mail-email'),
        email_re = /[^\s@]+@[^\s@]+\.[^\s@]+/,
        error    = false,
        form$    = $('#contact-form');

    if (message$.val().length == 0) {
      error = true;
      message$.addClass('input-error');
    } else {
      message$.removeClass('input-error');
    }

    if (!email_re.test(email$.val())) {
      error = true;
      email$.addClass('input-error');
    } else {
      email$.removeClass('input-error');
    }

    if (error) {
      return false;
    }

    form$.submit();

    $('#mail-us-modal').modal('close');
  })
});

addthis = function() {
  // remove addthis globals
  for (var i in window) {
    if (/^addthis/.test(i) || /^_at/.test(i)) {
      delete window[i];
    }
  }
  window.addthis_share = null;
  // load addthis script
  if ($('.addthis_toolbox').length > 0) {
    addthis_config = { "data_track_addressbar" : true };
    $.getScript("//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-5326371b24ec2b84");
  }
}

$(document).ready(addthis);