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
      'method': 'feed',
      'link': document.location.href,
      'name': 'Adopt this pet',
      'caption': 'Pics for Pets',
      'description': 'You MUST adopt this pet.',
      'picture': 'http://mchitten.com/system/posts/images/000/000/011/gallery/700.jpg'
    }, function(response) {
      $.post('/shares', { 'share': { 'post_id': id } }, function(res) {

      });
    });
    return false;
  });
});

