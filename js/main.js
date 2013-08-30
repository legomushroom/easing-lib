// Generated by CoffeeScript 1.6.2
(function() {
  require(['createGraph', 'Tween', 'EaseLib'], function(createGraph, TWEEN, EaseLib) {
    var animate, init;

    init = function() {
      var target;

      target = document.getElementById("target");
      target.appendChild(document.createElement("br"));
      target.appendChild(createGraph("Quake.Out", new EaseLib.Quake.Out));
      target.appendChild(createGraph("Quake.In", new EaseLib.Quake.In));
      target.appendChild(document.createElement("br"));
      return target.appendChild(createGraph("Quartic.In", TWEEN.Easing.Quartic.In));
    };
    animate = function() {
      requestAnimationFrame(animate);
      return TWEEN.update();
    };
    init();
    return animate();
  });

}).call(this);
