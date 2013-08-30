require ['createGraph', 'Tween', 'EaseLib'], (createGraph, TWEEN, EaseLib)->
    init = ->
        target = document.getElementById("target")
        target.appendChild document.createElement("br")
        target.appendChild createGraph "Quake.Out",     new EaseLib.Quake.Out
        target.appendChild createGraph "Quake.In",      new EaseLib.Quake.In
        target.appendChild createGraph "Quake.InOut",   new EaseLib.Quake.InOut
        target.appendChild document.createElement("br")
        target.appendChild createGraph("Quartic.In", TWEEN.Easing.Quartic.In)
        target.appendChild createGraph("Quartic.Out", TWEEN.Easing.Quartic.Out)
        target.appendChild createGraph("Quartic.InOut", TWEEN.Easing.Quartic.InOut)

    animate = ->
        requestAnimationFrame animate
        TWEEN.update()
    init()
    animate()