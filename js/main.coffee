require ['createGraph', 'Tween', 'EaseLib'], (createGraph, TWEEN, EaseLib)->
    init = ->
        target = document.getElementById("target")
        target.appendChild document.createElement("br")
        target.appendChild createGraph("Quake.Out", new EaseLib.Quake.Out(5,10))
        target.appendChild createGraph("Quake.In", EaseLib.Quake.In)
        target.appendChild document.createElement("br")
        target.appendChild createGraph("Quartic.In", TWEEN.Easing.Quartic.In)

    animate = ->
        requestAnimationFrame animate
        TWEEN.update()
    init()
    animate()