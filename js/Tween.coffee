

define 'Tween', ->
	###
	@author sole / http://soledadpenades.com
	@author mrdoob / http://mrdoob.com
	@author Robert Eisele / http://www.xarg.org
	@author Philippe / http://philippe.elsass.me
	@author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	@author Paul Lewis / http://www.aerotwist.com/
	@author lechecacharro
	@author Josh Faul / http://jocafa.com/
	@author egraether / http://egraether.com/
	@author endel / http://endel.me
	@author Ben Delarre / http://delarre.net
	###

	# Date.now shim for (ahem) Internet Explo(d|r)er
	if Date.now is `undefined`
	  Date.now = ->
	    new Date().valueOf()
	TWEEN = TWEEN or (->
	  _tweens = []
	  REVISION: "11dev"
	  getAll: ->
	    _tweens

	  removeAll: ->
	    _tweens = []

	  add: (tween) ->
	    _tweens.push tween

	  remove: (tween) ->
	    i = _tweens.indexOf(tween)
	    _tweens.splice i, 1  if i isnt -1

	  update: (time) ->
	    return false  if _tweens.length is 0
	    i = 0
	    numTweens = _tweens.length
	    time = (if time isnt `undefined` then time else ((if typeof window isnt "undefined" and window.performance isnt `undefined` and window.performance.now isnt `undefined` then window.performance.now() else Date.now())))
	    while i < numTweens
	      if _tweens[i].update(time)
	        i++
	      else
	        _tweens.splice i, 1
	        numTweens--
	    true
	)()
	TWEEN.Tween = (object) ->
	  _object = object
	  _valuesStart = {}
	  _valuesEnd = {}
	  _valuesStartRepeat = {}
	  _duration = 1000
	  _repeat = 0
	  _yoyo = false
	  _reversed = false
	  _delayTime = 0
	  _startTime = null
	  _easingFunction = TWEEN.Easing.Linear.None
	  _interpolationFunction = TWEEN.Interpolation.Linear
	  _chainedTweens = []
	  _onStartCallback = null
	  _onStartCallbackFired = false
	  _onUpdateCallback = null
	  _onCompleteCallback = null
	  
	  # Set all starting values present on the target object
	  for field of object
	    _valuesStart[field] = parseFloat(object[field], 10)
	  @to = (properties, duration) ->
	    _duration = duration  if duration isnt `undefined`
	    _valuesEnd = properties
	    @

	  @start = (time) ->
	    TWEEN.add this
	    _onStartCallbackFired = false
	    _startTime = (if time isnt `undefined` then time else ((if typeof window isnt "undefined" and window.performance isnt `undefined` and window.performance.now isnt `undefined` then window.performance.now() else Date.now())))
	    _startTime += _delayTime
	    for property of _valuesEnd
	      
	      # check if an Array was provided as property value
	      if _valuesEnd[property] instanceof Array
	        continue  if _valuesEnd[property].length is 0
	        
	        # create a local copy of the Array with the start value at the front
	        _valuesEnd[property] = [_object[property]].concat(_valuesEnd[property])
	      _valuesStart[property] = _object[property]
	      _valuesStart[property] *= 1.0  if (_valuesStart[property] instanceof Array) is false # Ensures we're using numbers, not strings
	      _valuesStartRepeat[property] = _valuesStart[property] or 0
	    @

	  @stop = ->
	    TWEEN.remove this
	    this

	  @delay = (amount) ->
	    _delayTime = amount
	    this

	  @repeat = (times) ->
	    _repeat = times
	    this

	  @yoyo = (yoyo) ->
	    _yoyo = yoyo
	    this

	  @easing = (easing) ->
	    _easingFunction = easing
	    this

	  @interpolation = (interpolation) ->
	    _interpolationFunction = interpolation
	    this

	  @chain = ->
	    _chainedTweens = arguments_
	    this

	  @onStart = (callback) ->
	    _onStartCallback = callback
	    this

	  @onUpdate = (callback) ->
	    _onUpdateCallback = callback
	    this

	  @onComplete = (callback) ->
	    _onCompleteCallback = callback
	    this

	  @update = (time) ->
	    property = undefined
	    return true  if time < _startTime
	    if _onStartCallbackFired is false
	      _onStartCallback.call _object  if _onStartCallback isnt null
	      _onStartCallbackFired = true
	    elapsed = (time - _startTime) / _duration
	    elapsed = (if elapsed > 1 then 1 else elapsed)
	    value = _easingFunction(elapsed)
	    for property of _valuesEnd
	      start = _valuesStart[property] or 0
	      end = _valuesEnd[property]
	      if end instanceof Array
	        _object[property] = _interpolationFunction(end, value)
	      else
	        
	        # Parses relative end values with start as base (e.g.: +10, -3)
	        end = start + parseFloat(end, 10)  if typeof (end) is "string"
	        
	        # protect against non numeric properties.
	        _object[property] = start + (end - start) * value  if typeof (end) is "number"
	    _onUpdateCallback.call _object, value  if _onUpdateCallback isnt null
	    if elapsed is 1
	      if _repeat > 0
	        _repeat--  if isFinite(_repeat)
	        
	        # reassign starting values, restart by making startTime = now
	        for property of _valuesStartRepeat
	          _valuesStartRepeat[property] = _valuesStartRepeat[property] + parseFloat(_valuesEnd[property], 10)  if typeof (_valuesEnd[property]) is "string"
	          if _yoyo
	            tmp = _valuesStartRepeat[property]
	            _valuesStartRepeat[property] = _valuesEnd[property]
	            _valuesEnd[property] = tmp
	            _reversed = not _reversed
	          _valuesStart[property] = _valuesStartRepeat[property]
	        _startTime = time + _delayTime
	        return true
	      else
	        _onCompleteCallback.call _object  if _onCompleteCallback isnt null
	        i = 0
	        numChainedTweens = _chainedTweens.length

	        while i < numChainedTweens
	          _chainedTweens[i].start time
	          i++
	        return false
	    true

	TWEEN.Easing =
	  Linear:
	    None: (k) ->
	      k

	  Quadratic:
	    In: (k) ->
	      k * k

	    Out: (k) ->
	      k * (2 - k)

	    InOut: (k) ->
	      return 0.5 * k * k  if (k *= 2) < 1
	      -0.5 * (--k * (k - 2) - 1)

	  Cubic:
	    In: (k) ->
	      k * k * k

	    Out: (k) ->
	      --k * k * k + 1

	    InOut: (k) ->
	      return 0.5 * k * k * k  if (k *= 2) < 1
	      0.5 * ((k -= 2) * k * k + 2)

	  Quartic:
	    In: (k) ->
	      k * k * k * k

	    Out: (k) ->
	      1 - (--k * k * k * k)

	    InOut: (k) ->
	      return 0.5 * k * k * k * k  if (k *= 2) < 1
	      -0.5 * ((k -= 2) * k * k * k - 2)

	  Quintic:
	    In: (k) ->
	      k * k * k * k * k

	    Out: (k) ->
	      --k * k * k * k * k + 1

	    InOut: (k) ->
	      return 0.5 * k * k * k * k * k  if (k *= 2) < 1
	      0.5 * ((k -= 2) * k * k * k * k + 2)

	  Sinusoidal:
	    In: (k) ->
	      1 - Math.cos(k * Math.PI / 2)

	    Out: (k) ->
	      Math.sin k * Math.PI / 2

	    InOut: (k) ->
	      0.5 * (1 - Math.cos(Math.PI * k))

	  Exponential:
	    In: (k) ->
	      (if k is 0 then 0 else Math.pow(1024, k - 1))

	    Out: (k) ->
	      (if k is 1 then 1 else 1 - Math.pow(2, -10 * k))

	    InOut: (k) ->
	      return 0  if k is 0
	      return 1  if k is 1
	      return 0.5 * Math.pow(1024, k - 1)  if (k *= 2) < 1
	      0.5 * (-Math.pow(2, -10 * (k - 1)) + 2)

	  Circular:
	    In: (k) ->
	      1 - Math.sqrt(1 - k * k)

	    Out: (k) ->
	      Math.sqrt 1 - (--k * k)

	    InOut: (k) ->
	      return -0.5 * (Math.sqrt(1 - k * k) - 1)  if (k *= 2) < 1
	      0.5 * (Math.sqrt(1 - (k -= 2) * k) + 1)

	  Elastic:
	    In: (k) ->
	      s = undefined
	      a = 0.1
	      p = 0.4
	      return 0  if k is 0
	      return 1  if k is 1
	      if not a or a < 1
	        a = 1
	        s = p / 4
	      else
	        s = p * Math.asin(1 / a) / (2 * Math.PI)
	      -(a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p))

	    Out: (k) ->
	      s = undefined
	      a = 0.1
	      p = 0.4
	      return 0  if k is 0
	      return 1  if k is 1
	      if not a or a < 1
	        a = 1
	        s = p / 4
	      else
	        s = p * Math.asin(1 / a) / (2 * Math.PI)
	      a * Math.pow(2, -10 * k) * Math.sin((k - s) * (2 * Math.PI) / p) + 1

	    InOut: (k) ->
	      s = undefined
	      a = 0.1
	      p = 0.4
	      return 0  if k is 0
	      return 1  if k is 1
	      if not a or a < 1
	        a = 1
	        s = p / 4
	      else
	        s = p * Math.asin(1 / a) / (2 * Math.PI)
	      return -0.5 * (a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p))  if (k *= 2) < 1
	      a * Math.pow(2, -10 * (k -= 1)) * Math.sin((k - s) * (2 * Math.PI) / p) * 0.5 + 1

	  Back:
	    In: (k) ->
	      s = 1.70158
	      k * k * ((s + 1) * k - s)

	    Out: (k) ->
	      s = 1.70158
	      --k * k * ((s + 1) * k + s) + 1

	    InOut: (k) ->
	      s = 1.70158 * 1.525
	      return 0.5 * (k * k * ((s + 1) * k - s))  if (k *= 2) < 1
	      0.5 * ((k -= 2) * k * ((s + 1) * k + s) + 2)

	  Bounce:
	    In: (k) ->
	      1 - TWEEN.Easing.Bounce.Out(1 - k)

	    Out: (k) ->
	      if k < (1 / 2.75)
	        7.5625 * k * k
	      else if k < (2 / 2.75)
	        7.5625 * (k -= (1.5 / 2.75)) * k + 0.75
	      else if k < (2.5 / 2.75)
	        7.5625 * (k -= (2.25 / 2.75)) * k + 0.9375
	      else
	        7.5625 * (k -= (2.625 / 2.75)) * k + 0.984375

	    InOut: (k) ->
	      return TWEEN.Easing.Bounce.In(k * 2) * 0.5  if k < 0.5
	      TWEEN.Easing.Bounce.Out(k * 2 - 1) * 0.5 + 0.5

	TWEEN.Interpolation =
	  Linear: (v, k) ->
	    m = v.length - 1
	    f = m * k
	    i = Math.floor(f)
	    fn = TWEEN.Interpolation.Utils.Linear
	    return fn(v[0], v[1], f)  if k < 0
	    return fn(v[m], v[m - 1], m - f)  if k > 1
	    fn v[i], v[(if i + 1 > m then m else i + 1)], f - i

	  Bezier: (v, k) ->
	    b = 0
	    n = v.length - 1
	    pw = Math.pow
	    bn = TWEEN.Interpolation.Utils.Bernstein
	    i = undefined
	    i = 0
	    while i <= n
	      b += pw(1 - k, n - i) * pw(k, i) * v[i] * bn(n, i)
	      i++
	    b

	  CatmullRom: (v, k) ->
	    m = v.length - 1
	    f = m * k
	    i = Math.floor(f)
	    fn = TWEEN.Interpolation.Utils.CatmullRom
	    if v[0] is v[m]
	      i = Math.floor(f = m * (1 + k))  if k < 0
	      fn v[(i - 1 + m) % m], v[i], v[(i + 1) % m], v[(i + 2) % m], f - i
	    else
	      return v[0] - (fn(v[0], v[0], v[1], v[1], -f) - v[0])  if k < 0
	      return v[m] - (fn(v[m], v[m], v[m - 1], v[m - 1], f - m) - v[m])  if k > 1
	      fn v[(if i then i - 1 else 0)], v[i], v[(if m < i + 1 then m else i + 1)], v[(if m < i + 2 then m else i + 2)], f - i

	  Utils:
	    Linear: (p0, p1, t) ->
	      (p1 - p0) * t + p0

	    Bernstein: (n, i) ->
	      fc = TWEEN.Interpolation.Utils.Factorial
	      fc(n) / fc(i) / fc(n - i)

	    Factorial: (->
	      a = [1]
	      (n) ->
	        s = 1
	        i = undefined
	        return a[n]  if a[n]
	        i = n
	        while i > 1
	          s *= i
	          i--
	        a[n] = s
	    )()
	    CatmullRom: (p0, p1, p2, p3, t) ->
	      v0 = (p2 - p0) * 0.5
	      v1 = (p3 - p1) * 0.5
	      t2 = t * t
	      t3 = t * t2
	      (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1

	TWEEN