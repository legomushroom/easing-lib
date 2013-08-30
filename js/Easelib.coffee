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
						1 - b

			@Quake.In = class QuakeIn 
				constructor:(coef1=1, coef2=5)->
					return (t)->
						b = (t*t*Math.cos(Math.PI*2*t*coef2))/coef1
						b

			


	new Easings
		
	
