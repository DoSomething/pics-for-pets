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

  remove_crop = function(e) {
    if(e)
      e.preventDefault();
    $("#crop-container").remove();
    $("#crop-overlay").remove();
    $("body").off("keydown");
  }

  reset_img = function(e) {
    e.preventDefault();
    $("#post_image").wrap('<form>').closest('form').get(0).reset();
    $("#post_image").unwrap();
    $('#upload-preview span.text').show();
    $('#upload-preview').removeClass('loading');
    remove_crop();
  }

  crop_upload = function(filename) {
    //append necessary html and style
    $('#upload-preview span.text').hide();
    $('#upload-preview').addClass('loading');
    var overlay = $("<div></div>");
    overlay.attr("id", "crop-overlay");
    overlay.appendTo("body");
    var container = $("<div></div>");
    container.attr("id", "crop-container");
    container.appendTo("body");
    var header = $('<h2>Squarify your image!</h2>');
    header.appendTo("#crop-container");
    var img_container = $("<div></div>");
    img_container.attr("id", "crop-img-container");
    img_container.appendTo("#crop-container");
    var img = $('<img />');
    img.attr('src', '/system/tmp/' + filename);
    img.appendTo('#crop-img-container');
    img.load(function() {
      img.css({height: ($(window).height() - header.height() - $("#crop-button").height() - 125) + "px"});
      if(img.width() > $(window).width() - 120)
        img.css({
          width: ($(window).width() - 120) + "px",
          height: "auto"
        });
      $("#crop_dim_w").val(img.width());
      var cropbox_dim = img.width() > img.height() ? img.height() : img.width();
      
      //add crop ability
      update_crop = function(coords) {
        $("#crop_x").val(coords.x);
        $("#crop_y").val(coords.y);
        $("#crop_w").val(coords.w);
        $("#crop_h").val(coords.h);
      }

      img.Jcrop({
        onChange: update_crop,
        onSelect: update_crop,
        setSelect: [0, 0, cropbox_dim, cropbox_dim],
        aspectRatio: 1
      });
    });
    var crop_button = $("<a href='#' class='btn primary'>Crop</a>");
    crop_button.attr("id", "crop-button");
    crop_button.appendTo('#crop-container');
    var cancel_button = $("<a href='#' class='btn secondary'>Cancel</a>");
    cancel_button.attr("id", "cancel-button");
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
  }

  change_upload = function(filename, width, height) {
    $('#upload-box').find('span').hide();
    var preview_size = $("#upload-preview").height();
    var img_container = $("<div></div>")
    img_container.attr("id", "preview-img-container");
    img_container.css({
      width: $("#crop_w").val(),
      height: $("#crop_h").val(),
      transform: "scale(" + (preview_size / $("#crop_w").val()) +")",
      marginLeft: (Math.round(preview_size / 2) - $("#crop_w").val() / 2) + "px",
      marginTop: (Math.round(preview_size / 2) - $("#crop_h").val() / 2) + "px",
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
    else {
      $('#upload-preview span.text').show();
      $('#upload-preview').removeClass('loading');
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