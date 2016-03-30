"use strict";

if (location.hash == "#kiosk") {
  $(function startKioskMode() {

    var rate = 3000, // in ms
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

// function startKioskMode() {
//   var $items = $(".contributor");

//   var rate = 3000; // in ms
//   var currentPage = 0;
//   var perPage = 6;
//   var pageCount = Math.ceil(items.length / 6);

//   var step = function() {
//     var rangeStart = currentPage < pageCount ? currentPage * perPage : 0;
//     var rangeEnd = rangeStart + perPage;

//     console.info("step()", pageCount, perPage, currentPage, rangeStart, rangeEnd);

//     for (var i = 0; i < items.length; i++) {
//       var item = items[i];

//       item.style.visibility = "visible";

//       if (i >= rangeStart && i < rangeEnd) {
//         item.hidden = false;
//       } else {
//         item.hidden = true;
//       }
//     }

//     currentPage = currentPage < pageCount ? currentPage + 1 : 0;
//   };

//   step();

//   setInterval(step2, rate);
// }
