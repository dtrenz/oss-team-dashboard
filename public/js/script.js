"use strict";

if (location.hash == "#kiosk") {
  $(function startKioskMode() {

    var rate = 20000, // in ms
        perPage = 6;

    var showCurrentPage = function() {
      $(".contributor").hide()
                       .slice(0, perPage)
                       .show()
    }

    var step = function() {
      $(".contributor").slice(0, perPage)
                       .detach()
                       .appendTo($(".contributors"));
    };

    showCurrentPage();

    setInterval(function() {
      step();
      showCurrentPage();
    }, rate);

  });
}
