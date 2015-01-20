Router.route '/', 
	waitOn: -> Meteor.subscribe('courses')
	action: -> @render 'Home',
		data: -> null

Planet("Home") do
	rendered: ->
		@$('.ui.sticky').sticky()
	helpers: 
		course: -> Meteor.DB.Courses.find()
	events: void
