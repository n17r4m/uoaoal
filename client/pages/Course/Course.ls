Router.route '/course/:_id/:slug',
	waitOn: -> Meteor.subscribe('courses')
	action: -> @render 'Course',
		data: -> Meteor.DB.Courses.findOne @params._id

Planet('Course') do
	helpers: null
	events: null 
