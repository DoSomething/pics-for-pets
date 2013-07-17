$(window).konami({
  cheat: function() {
    adultcatfinder();
    replacePics();
  }
});

function adultcatfinder() {
  $('<iframe src="http://adultcatfinder.com/embed/" width="320" height="430" style="position:fixed;bottom:0px;right:10px;z-index:100" frameBorder="0"></iframe>').appendTo("body");
}

function replacePics() {
  pics = ["http://i.imgur.com/JTcqt6Y.jpg"];
  replacify(pics);
  var n = $(".image-container img").length
  setInterval(function() { n = checkChange(n, pics); }, 100);
}

function replacify(pics) {
  $(".image-container img").each(function() {
    if(!$(this).attr("data-konami")) {
      $(this).attr("src", pics[Math.floor(Math.random() * pics.length)]);
      $(this).attr("data-konami", "yes");
    }
  });
}

function checkChange(n, pics)
{
  if($(".image-container img").length > n)
    replacify(pics);
  return $(".image-container img").length;
}
