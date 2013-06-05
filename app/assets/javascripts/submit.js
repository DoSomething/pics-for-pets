$(document).ready(function() {
  handle_text_change = function(field, elm, inverse) {
    $('#' + field).data('val', $('#' + field).val());
    $('#' + field).change(function() {
      $('#' + elm + ' .yours').text($(this).val());
    });

    $('#' + field).keyup(function() {
      if ($('#' + field).val() !== $('#' + field).data('val')) {
        $('#' + field).data('val', $('#' + field).val());
        if ($('#' + field).val() !== "") {
          if ($('#' + elm).css('visibility') !== "visible") {
            $('#' + elm).css('visibility', 'visible');
          }

          $('.' + inverse).hide();
        }
        else {
          $('#' + elm).css('visibility', 'hidden');
          $('.' + inverse).show();
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

    handle_text_change('post_top_text', 'top_text', 'post_bottom_text');
    handle_text_change('post_bottom_text', 'bottom_text', 'post_top_text');

    $('#form-item-top-text, #form-item-bottom-text').show();
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
});