// Navigation filter functionality
$(function() {

  // Populate the state filter
  // TODO - ADD FULL STATE NAMES
  var states = [
                  'ALL', 'AL',
                  'AK', 'AS', 'AZ', 'AR', 'CA',
                  'CO', 'CT', 'DE', 'DC', 'FM',
                  'FL', 'GA', 'GU', 'HI', 'ID',
                  'IL', 'IN', 'IA', 'KS', 'KY',
                  'LA', 'ME', 'MH', 'MD', 'MA',
                  'MI', 'MN', 'MS', 'MO', 'MT',
                  'NE', 'NV', 'NH', 'NJ', 'NM',
                  'NY', 'NC', 'ND', 'MP', 'OH',
                  'OK', 'OR', 'PW', 'PA', 'PR',
                  'RI', 'SC', 'SD', 'TN', 'TX',
                  'UT', 'VT', 'VI', 'VA', 'WA',
                  'WV', 'WI', 'WY'
                ];

  for (var i=0; i < states.length; i++) {
    $('#state_filter').append('<option value="' + states[i] + '">' + states[i] + '</option>');
  }

  // Get user filter input and set destination
  $('#submit_filter').click(function(){
    var animal = $('#animal_filter').val();
    var state = $('#state_filter').val();
    var $this = $(this);

    if( $('#state_filter').val() !== 'ALL' ) {
      $this.attr('href','/show/' + animal + '-' + state);
    }
    else {
      $this.attr('href','/show/' + animal);
    }

  });

});
