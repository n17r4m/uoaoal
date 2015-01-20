Router.route '/create', ->
	@render 'Create',
		data: -> null

Planet("Create") do
		events: 
			'submit form': (e) ->
				
				form = $(e.currentTarget)
				
				code = form.find('input[name=code]').val()
				name = form.find('input[name=name]').val()
				description = form.find('textarea[name=description]').val()
				tags = form.find('input[name=tags]').val()
				
				unless code then return alert('Course code is required') && false
				unless name then return alert('Course name is required') && false
				
				course = {code, name, description, tags}
				
				id = Meteor.DB.Courses.insert(course)
				Router.go("/manage/#{id}")
				
				return false
