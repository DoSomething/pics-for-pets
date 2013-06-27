$(document).ready(function(){

  var nPets = $("#petsBar").data("total");
  var nUsers = $("#usersBar").data("total");
  var nShares = $("#sharesBar").data("total");

  //pets pie
  var petsPieData = [
    ['Cats', $("#petsPie").data("cats")],['Dogs', $("#petsPie").data("dogs")], ['Other', $("#petsPie").data("others")]
  ];
  var petsPie = jQuery.jqplot ('petsPie', [petsPieData], 
    { 
      title: "Pet Type Percentage",
      seriesDefaults: {
        // Make this a pie chart.
        renderer: jQuery.jqplot.PieRenderer, 
        rendererOptions: {
          // Put data labels on the pie slices.
          // By default, labels show the percentage of the slice.
          showDataLabels: true
        }
      }, 
      legend: { show:true, location: 'e' }
    }
  );

  //pets bar
  var total = [$("#petsBar").data("total")];
  var cats = [$("#petsBar").data("cats")];
  var dogs = [$("#petsBar").data("dogs")];
  var others = [$("#petsBar").data("others")];
  // Can specify a custom tick Array.
  // Ticks should match up one for each y value (category) in the series.
  var ticks = ['All time'];
  var petsBar = $.jqplot('petsBar', [total, cats, dogs, others], {
      title: "Number of Pets",
      // The "seriesDefaults" option is an options object that will
      // be applied to all series in the chart.
      seriesDefaults:{
          renderer:$.jqplot.BarRenderer,
          rendererOptions: {fillToZero: true},
          pointLabels: { show: true, location: 'n', edgeTolerance: -15 },
      },
      // Custom labels for the series are specified with the "label"
      // option on the series option.  Here a series option object
      // is specified for each series.
      series:[
          {label:'Total Pets'},
          {label:'Cats'},
          {label:'Dogs'},
          {label:'Others'}
      ],
      // Show the legend and put it outside the grid, but inside the
      // plot container, shrinking the grid to accomodate the legend.
      // A value of "outside" would not shrink the grid and allow
      // the legend to overflow the container.
      legend: {
          show: true,
          placement: 'outsideGrid'
      },
      axes: {
          // Use a category axis on the x axis and use our custom ticks.
          xaxis: {
              renderer: $.jqplot.CategoryAxisRenderer,
              ticks: ticks
          },
          // Pad the y axis just a little so bars can get close to, but
          // not touch, the grid boundaries.  1.2 is the default padding.
      }
  });

  //users bar
  var total = [$("#usersBar").data("total")];
  var mean = [ nPets / nUsers ];
  var shares = [ nShares / nUsers ]
  // Can specify a custom tick Array.
  // Ticks should match up one for each y value (category) in the series.
  var ticks = ['All time'];
  var usersBar = $.jqplot('usersBar', [total, mean, shares], {
      title: "User Stats",
      // The "seriesDefaults" option is an options object that will
      // be applied to all series in the chart.
      seriesDefaults:{
          renderer:$.jqplot.BarRenderer,
          rendererOptions: {fillToZero: true},
          pointLabels: { show: true, location: 'n', edgeTolerance: -15 },
      },
      // Custom labels for the series are specified with the "label"
      // option on the series option.  Here a series option object
      // is specified for each series.
      series:[
          {label:'Total Users'},
          {label:'Posts per user'},
          {label: 'Shares per user'}
      ],
      // Show the legend and put it outside the grid, but inside the
      // plot container, shrinking the grid to accomodate the legend.
      // A value of "outside" would not shrink the grid and allow
      // the legend to overflow the container.
      legend: {
          show: true,
          placement: 'outsideGrid'
      },
      axes: {
          // Use a category axis on the x axis and use our custom ticks.
          xaxis: {
              renderer: $.jqplot.CategoryAxisRenderer,
              ticks: ticks
          },
          // Pad the y axis just a little so bars can get close to, but
          // not touch, the grid boundaries.  1.2 is the default padding.
      }
  });

  //shares bar
  var total = [$("#sharesBar").data("total")];
  var cat = [$("#sharesBar").data("cat")];
  var dog = [$("#sharesBar").data("dog")];
  var other = [$("#sharesBar").data("other")];
  var mean = [ nShares / nPets ];
  // Can specify a custom tick Array.
  // Ticks should match up one for each y value (category) in the series.
  var ticks = ['All time'];
  var sharesBar = $.jqplot('sharesBar', [total, cat, dog, other, mean], {
      title: "Share Stats",
      // The "seriesDefaults" option is an options object that will
      // be applied to all series in the chart.
      seriesDefaults:{
          renderer:$.jqplot.BarRenderer,
          rendererOptions: {fillToZero: true},
          pointLabels: { show: true, location: 'n', edgeTolerance: -15 },
      },
      // Custom labels for the series are specified with the "label"
      // option on the series option.  Here a series option object
      // is specified for each series.
      series:[
          {label:'Total Shares'},
          {label:'Cat Shares'},
          {label:'Dog Shares'},
          {label:'Other Shares'},
          {label:'Shares per Post'}
      ],
      // Show the legend and put it outside the grid, but inside the
      // plot container, shrinking the grid to accomodate the legend.
      // A value of "outside" would not shrink the grid and allow
      // the legend to overflow the container.
      legend: {
          show: true,
          placement: 'outsideGrid'
      },
      axes: {
          // Use a category axis on the x axis and use our custom ticks.
          xaxis: {
              renderer: $.jqplot.CategoryAxisRenderer,
              ticks: ticks
          },
          // Pad the y axis just a little so bars can get close to, but
          // not touch, the grid boundaries.  1.2 is the default padding.
      }
  });

});