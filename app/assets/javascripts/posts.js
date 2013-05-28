// POSTS
// -----
$(function() {
  // AUTOMATICALLY RESIZE BTN WIDTHS
  set_width = function(parent, child, width) {
    $(parent).each(function() {
      var $this = $(this);
      var child_width = $this.find(child).width() * width;
      $this.css('width', child_width);
    });
  };
  set_width('a.btn', 'span', 1.3);

  // SHOW & HIDE DEBUG INFORMATION
  $debug = $('.debug');
  $debug.hide();

  $('#debug').click(function() {
    $debug.slideToggle('fast');
  });

  // FACEBOOK POST SHARING FUNCTIONALITY
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

  // END
});

