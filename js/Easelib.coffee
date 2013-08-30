define 'EaseLib', ->
	class Easings
		constructor: (o) ->
			@createEasings()

		createEasings:->

			@Quake = {}
			
			@Quake.Out = (t)->
				b = Math.exp(-t*10)*Math.cos(Math.PI*2*t*10)
				if t >= 1 then return 1
				1 - b

			@Quake.In = (t)->
				b = Math.exp(-t*10)*Math.cos(Math.PI*2*t*10)
				if t >= 1 then return 1
				1 - b


	new Easings
		
	
