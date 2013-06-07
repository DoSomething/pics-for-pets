$(document).ready(function() {
  handle_text_change = function(field) {
    var elm;

    $('#' + field).data('val', $('#' + field).val());
    $('#' + field).change(function() {
      $('#' + elm + ' .yours').text($(this).val());
    });

    $('#' + field).keyup(function() {
      elm = $('#post_meme_position').val() + '_text';
      if ($('#' + field).val() !== $('#' + field).data('val')) {
        $('#' + field).data('val', $('#' + field).val());
        if ($('#' + field).val() !== "") {
          $('#' + elm).show().css('visibility', 'visible');
        }
        else {
          $('.text-pos').hide();
        }

        $(this).change();
      }
    });
  };

  function remove_crop(e) {
    if(e)
      e.preventDefault();
    $("#crop-container").remove();
    $("#crop-overlay").remove();
    $("body").off("keydown");
  }

  function reset_img(e) {
    e.preventDefault();
    $("#post_image").wrap('<form>').closest('form').get(0).reset();
    $("#post_image").unwrap();
    remove_crop();
  }

  function crop_upload(filename) {
    //append necessary html and style
    var overlay = $("<div></div>");
    overlay.css({
      position: "fixed",
      top: 0,
      left: 0,
      height: "100%",
      width: "100%",
      background: "rgba(0,0,0,0.7)",
      zIndex: "999"
    });
    overlay.attr("id", "crop-overlay");
    overlay.appendTo("body");
    var container = $("<div></div>");
    container.attr("id", "crop-container");
    container.css({
      position: "fixed",
      top: "50%",
      left: "50%",
      "max-height": "80%",
      "max-width": "80%",
      overflow: "scroll",
      background: "white",
      border: "2em solid white",
      "border-radius": "1em",
      transform: "translate(-50%, -50%)",
      "-ms-transform": "translate(-50%, -50%)",
      "-webkit-transform": "translate(-50%, -50%)",
      zIndex: "1000"
    });
    container.appendTo("body");
    var header = $('<h2>Squarify your image!</h2>');
    header.appendTo("#crop-container");
    var img_container = $("<div></div>");
    img_container.attr("id", "crop-img-container");
    img_container.css({ padding: "5px" });
    img_container.appendTo("#crop-container");
    var img = $('<img />');
    img.load(function() {
      if(img.width() > img.height())
        img.css({ height: "450px" });
      else
        img.css({ width: "450px" });
    });
    img.attr('src', '/system/tmp/' + filename);
    img.appendTo('#crop-img-container');
    var crop_button = $("<a href='#' class='btn'>Crop</a>");
    crop_button.css({
      clear: "none",
      "float": "left",
      margin: "0.5em 0",
      width: "46%",
      marginLeft: "2%"
    });
    crop_button.appendTo('#crop-container');
    var cancel_button = $("<a href='#' class='btn secondary'>Cancel</a>");
    cancel_button.css({
      clear: "none",
      "float": "right",
      margin: "0.5em 0",
      width: "46%",
      marginRight: "2%"
    });
    cancel_button.appendTo('#crop-container');

    //add appropriate handlers
    crop_button.click(function(e) {
      remove_crop(e);
      change_upload(filename, img.width(), img.height());
    });
    cancel_button.click(function(e) {
      reset_img(e);
    });
    overlay.click(function(e) {
      reset_img(e);
    });
    $("body").keydown(function(e) {
      if((e.which) == 27)
        reset_img(e);
    });

    //add crop ability
    function update_crop(coords) {
      $("#crop_x").val(coords.x);
      $("#crop_y").val(coords.y);
      $("#crop_w").val(coords.w);
      $("#crop_h").val(coords.h);
    }

    img.Jcrop({
      onChange: update_crop,
      onSelect: update_crop,
      setSelect: [0, 0, 450, 450],
      aspectRatio: 1
    });
  }

  change_upload = function(filename, width, height) {
    $('#upload-box').find('span').hide();
    var img_container = $("<div></div>")
    img_container.attr("id", "preview-img-container");
    img_container.css({
      width: $("#crop_w").val(),
      height: $("#crop_h").val(),
      transform: "scale(" + (450 / $("#crop_w").val()) +")",
      marginLeft: (225 - $("#crop_w").val() / 2) + "px",
      marginTop: (225 - $("#crop_h").val() / 2) + "px",
      zIndex: 0,
      position: "absolute",
      overflow: "hidden"
    });
    img_container.appendTo('#upload-preview');
    var img = $('<img />');
    img.attr('src', '/system/tmp/' + filename);
    img.css({
      width: width + "px",
      height: height + "px",
      marginLeft: "-" + $("#crop_x").val() + "px",
      marginTop: "-" + $("#crop_y").val() + "px"
    });
    $('#upload-preview span').hide();
    img.appendTo('#preview-img-container');

    handle_text_change('post_meme_text');

    $('.form-item-meme-text, .form-item-meme-position').show();
  };

  $('#post_image').change(function() {
    $("#preview-img-container").remove();

    if($(this).val() != "") {
      var file_data = $("#post_image").prop("files")[0];
      if (!file_data.type.match(/image\/(jpeg|gif|png)/)) {
        $('#image_error').show();
        return false;
      }

      $('#upload-preview span.text').hide();
      $('#upload-preview').addClass('loading');

      var form_data = new FormData();
      form_data.append("file", file_data);
      $.ajax({
        url: "/autoimg",
        dataType: 'script',
        cache: false,
        contentType: false,
        processData: false,
        data: form_data,
        type: 'post',
        complete: function(response) {
          res = $.parseJSON(response.responseText);
          if (res.success === true) {
            crop_upload(res.filename);
          }
        }
      });
    }
  });

  $('#post_meme_position').change(function() {
    var e = $(this).val();
    var val = $('#post_meme_text').val();

    $('.text-pos').hide();
    $('#' + e + '_text').find('.yours').text(val);
    if (val !== "") {
      $('#' + e + '_text').show().css('visibility', 'visible');
    }
  });
});