"use strict";

window.onload = function() {
  if (location.hash == "#kiosk") {
    startKioskMode();
  }
};

function startKioskMode() {
  var items = document.querySelectorAll(".contributor");

  var rate = 20000; // in ms
  var currentPage = 0;
  var perPage = 6;
  var pageCount = Math.ceil(items.length / 6);

  var step = function() {
    var rangeStart = currentPage < pageCount ? currentPage * perPage : 0;
    var rangeEnd = rangeStart + perPage;

    console.info("step()", pageCount, perPage, currentPage, rangeStart, rangeEnd);

    for (var i = 0; i < items.length; i++) {
      var item = items[i];

      item.style.visibility = "visible";

      if (i >= rangeStart && i < rangeEnd) {
        item.hidden = false;
      } else {
        item.hidden = true;
      }
    }

    currentPage = currentPage < pageCount ? currentPage + 1 : 0;
  };

  step();

  setInterval(step, rate);
}
