// POSTS
// -----
$(function() {
  $debug = $('.debug');
  $debug.hide();

  $('#debug').click(function() {
    $debug.slideToggle('fast');
  });

  $('.facebook-share').click(function() {
    var id = $(this).attr('data-id');
    FB.ui({
      method: 'share'
    }, function(response) {
      $.post('/shares', { 'share': { 'uid': 1, 'post_id': id } }, function(res) {
        console.log(res);
      });
    });
    return false;
  });
});

