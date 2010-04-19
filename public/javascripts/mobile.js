if (window.navigator.standalone) {
  $("#installation").hide();
  var $container = $("#container");
  $container.attr("id", "jqt");
  $container.show();
  jQT = new $.jQTouch({
    statusBar: "black",
    preloadImages: [
    "/jqtouch/themes/apple/img/backButton.png",
    "/jqtouch/themes/apple/img/chevron.png",
    "/jqtouch/themes/apple/img/listGroup.png",
    "/jqtouch/themes/apple/img/pinstripes.png",
    "/jqtouch/themes/apple/img/selection.png",
    "/jqtouch/themes/apple/img/thumb.png",
    "/jqtouch/themes/apple/img/toggle.png",
    "/jqtouch/themes/apple/img/toggleOn.png",
    "/jqtouch/themes/apple/img/toolbar.png",
    "/jqtouch/themes/apple/img/toolButton.png"
    ]
  });
} else {
  $("#installation").show();
  var ctx = document.getCSSCanvasContext("2d", "arrow", 30, 30);
  ctx.fillStyle = "rgb(222,245,168)";
  ctx.beginPath();
  ctx.moveTo(0, 0);
  ctx.lineTo(30, 0);
  ctx.lineTo(15,23);
  ctx.closePath();
  ctx.fill();
}