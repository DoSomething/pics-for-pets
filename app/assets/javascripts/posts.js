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

  $('#debug').unbind('click').click(function() {
    $debug.slideToggle('fast');
    return false;
  });

  // FACEBOOK POST SHARING FUNCTIONALITY
  $('.facebook-share').click(function() {
    var id = $(this).attr('data-id');
    var name = $(this).parent().parent().find('span.name').text();
    var picture = $(this).parent().parent().find('img').attr('src');

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

  // PET FINDER SHELTER LOCATOR
  var $err = $('#shelter-finder .error');
  $err.hide();
  $('#shelter-submit').click(function() {
    var zip = $('#shelter-zip').val();
    var dest = 'http://www.petfinder.com/awo/index.cgi?location=' + zip + '&keyword=';
    if( zip.match(/^\d{5}$/)  ) {
      $('#shelter-submit').attr('href', dest);
    }
    else {
      $err.show();
      return false;
    }
  });

  // END
});

