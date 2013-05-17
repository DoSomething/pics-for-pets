// Navigation filter functionality
$(function() {

  $('#submit_filter').click(function(){
    var selection = $('#animal_filter').val();
    $(this).attr('href','/show/' + selection);
  });

});
