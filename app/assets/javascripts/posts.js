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

  // ABSTRACTS FACEBOOK CLICK FOR INFINITE SCROLL
  load_facebook = function() {
    // Remove previous click event
    $('.facebook-share').unbind('click');
    $('.facebook-share').click(function() {
      var id = $(this).attr('data-id');
      var name = $(this).parent().parent().find('span.name').text();
      var picture = document.location.origin + $(this).parent().parent().find('img').attr('src');

      FB.ui({
        'method': 'feed',
        'link': document.location.href,
        'name': 'Want to adopt me?',
        'caption': 'Pics for Pets',
        'description': name + ' is super cute and deserves a loving home.  Could you be ' + name + '\'s new owner?',
        'picture': picture
      }, function(response) {
        if (response && response.post_id) {
          $.post('/shares', { 'share': { 'post_id': id } }, function(res) {});
        }
      });
      return false;
    });
  };

  set_width('a.btn', 'span', 1.3);

  // SHOW & HIDE DEBUG INFORMATION
  $debug = $('.debug');
  $debug.hide();

  $('#debug').unbind('click').click(function() {
    $debug.slideToggle('fast');
    return false;
  });

  // FACEBOOK POST SHARING FUNCTIONALITY
  load_facebook();

  // END
});

