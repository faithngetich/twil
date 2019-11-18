$(document).ready(function() {
  var checkForOneTouch = function() {
    $.get('/authy/status', function(data) {
      if (data === 'approved') {
        window.location.href = '/';
      }else {
        setTimeout(checkForOneTouch, 2000);
      }
    });
  };
  var attemptOneTouchVerification = function(form) {
    $.post('/session', form, function(data) {
      $('#authy-modal').show();
      if (data.success) {
        var fadeIn = $('.auth-ot');
        $('.auth-ot').fadeIn();
        checkForOneTouch()
      } else {
        $('.auth-token').fadeIn();
      }
    });
  };
  $('form').submit(function(e) {
    e.preventDefault();
    var formData = $(e.currentTarget).serialize();
    attemptOneTouchVerification(formData);
  });
});
