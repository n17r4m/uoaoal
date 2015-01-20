Planet('nestitem') do
	helpers: 
		nestdata: ->
			attrs = {}
			for name, value of @ when name isnt \children
				attrs["data-#{name}"] = value
			attrs
