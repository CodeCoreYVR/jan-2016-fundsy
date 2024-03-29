$(document).ready(function(){
  var stripPublishableKey = $("meta[name='stripe-publishable-key']").attr("content");
  Stripe.setPublishableKey(stripPublishableKey);

  $("#payment-form").on("submit", function(event){
    event.preventDefault();
    $("#stripe-error-message").addClass("hide");
    $("#payment-form").find("input:submit").attr("disabled", true);
    Stripe.card.createToken($("#payment-form"), stripeResponseHandler);
  });

  var stripeResponseHandler = function(status, data) {
    if(status === 200) {
      // successful => submit second form to the server
      var token = data.id;
      $("#stripe_token").val(token);
      $("#server-form").submit();
    } else {
      var errMessage = data.error.message;
      $("#stripe-error-message").html(errMessage);
      $("#stripe-error-message").removeClass("hide");
      $("#payment-form").find("input:submit").attr("disabled", false);
    }
  }

});
