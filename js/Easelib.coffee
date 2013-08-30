define 'EaseLib', ->
	class Easings
		constructor: (o) ->
			@createEasings()

		createEasings:->

			@Quake = {}
			
			@Quake.Out = class QuakeOut 
				constructor:(coef1=5, coef2=5)->
					return (t)->
						b = Math.exp(-t*coef1)*Math.cos(Math.PI*2*t*coef2)
						if t >= 1 then return 1
						1 - b

			@Quake.In = (t)->
				b = Math.exp(-t*10)*Math.cos(Math.PI*2*t*10)
				if t >= 1 then return 1
				1 - b


	new Easings
		
	
