// GATE
// -----
$(function() {
  var $login_form = $('#login-form');
  var $login_link = $('.login-link');

  var $reg_form = $('#registration-form');
  var $reg_link = $('.registration-link');

  $login_link.click(function() {
    $reg_form.hide();
    $login_form.show();
    return false;
  });

  $reg_link.click(function() {
    $reg_form.show();
    $login_form.hide();
    return false;
  });

  // END
});

