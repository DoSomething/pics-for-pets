// POSTS
// -----
$(function() {
  // INITIALIZE FRIEND SELECTOR
  TDFriendSelector.init();

  friendselector = TDFriendSelector.newInstance({
    maxSelection: 1,
    autoDeselection: true,
    friendsPerPage: 7,
    callbackSubmit: function(selected, settings) {
      friend = parseInt(selected[0]);

      FB.ui({
        'to': friend,
        'method': 'feed',
        'link': 'http://pics.dosomething.org/' + settings['id'],
        'name': 'Want to adopt me?',
        'caption': 'Pics for Pets',
        'description': settings['name'] + ' is super cute and deserves a loving home.  Could you be ' + settings['name'] + '\'s new owner?',
        'picture': settings['picture']
      }, function(response) {
        if (response && response.post_id) {
          settings['share_elm'].text(++settings['share_count']);
          $.post('/shares', { 'share': { 'post_id': settings['id'] } }, function(res) {});
        }
        $('html,body').animate({ scrollTop: $('.id-' + settings['id']).offset().top }, 'fast');
      });
    }
  });

  // AUTOMATICALLY FORM IMAGE SIZE ON RESIZE
  maintain_ratio = function(target) {
    $target = $(target);
    $target.height($target.width());
    $(window).resize(function(){
      $target.height($target.width());
    });
  }
  maintain_ratio('#upload-preview');

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
    $('.facebook-share').click(function(e) {
      var $id = $(this).attr('data-id');
      var $name = $(this).parent().parent().find('span.name').text();
      var $picture = document.location.origin + $(this).parent().parent().find('img').attr('src');
      var $share_count = parseInt($(this).parent().find('.share-count').text());
      var $share_elm = $(this).parent().find('.share-count');

      e.preventDefault();
      friendselector.showFriendSelector({
        'id': $id,
        'name': $name,
        'picture': $picture,
        'share_count': $share_count,
        'share_elm': $share_elm
      });
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

