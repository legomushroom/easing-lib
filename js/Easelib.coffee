define 'EaseLib', ->
	class Easings
		constructor: (o) ->
			@createEasings()

		createEasings:->

			@Quake = {}
			
			@Quake.Out = class QuakeOut 
				constructor:(coef=5)->
					return (t)->
						b = Math.exp(-t*coef)*Math.cos(Math.PI*2*t*coef)
						1 - b

			@Quake.In = class QuakeIn 
				constructor:(coef=5)->
					return (t)->
						b = t*t*Math.cos(Math.PI*2*t*coef)
						b

			@Quake.InOut = class QuakeInOut
				constructor:(coef=5)->
					return (t)->
						t*t*Math.cos(Math.PI*2*t*coef)*Math.sin(Math.PI*2*t*80)
						

			


	new Easings
