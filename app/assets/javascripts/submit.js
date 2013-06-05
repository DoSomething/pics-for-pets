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

  change_upload = function(filename) {
    $('#upload-box').find('span').hide();
    var img = $('<img />');
    img.attr('src', '/system/tmp/' + filename);
    img.css({ 'width': '450px', 'height': '450px', 'position': 'absolute', 'z-index': 0 });
    $('#upload-preview span').hide();
    img.appendTo('#upload-preview');

    handle_text_change('post_meme_text');

    $('.form-item-meme-text, .form-item-meme-position').show();
  };

  $('#post_image').change(function() {
    $('#upload-preview span.text').hide();
    $('#upload-preview span.loading').show();

    var file_data = $("#post_image").prop("files")[0];
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
          change_upload(res.filename);
        }
      }
    });
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