Router.route '/course/:_id/:slug/:pageId/:pageSlug',
	waitOn: -> [
		Meteor.subscribe('courses', @params._id),
		Meteor.subscribe('contents', @params.pageId)
	]
	action: -> @render 'Page',
		data: -> {
			course: Meteor.DB.Courses.findOne @params._id
			content: Meteor.DB.Contents.findOne @params.pageId
		}

Planet('Page') do
	rendered: ->
		console.info @
		unless Template[@data.content._id]
			tpl = compileTemplate(@data.content._id, @data.content.content)
			if typeof! tpl isnt 'Function'
				console.info tpl
		if Template[@data.content._id]
			UI.insert(UI.render(Template[@data.content._id]), $('.page')[0])
			$('.ui.accordion').accordion()
	
	helpers:
		next: ->
			flat = flattenTree @course.contents, (item) -> item._id
			pos = flat.indexOf @content._id
			if pos < (flat.length - 1) 
				return Meteor.DB.Contents.findOne(flat[pos + 1])
			else return null
		prev: ->
			flat = flattenTree @course.contents, (item) -> item._id
			pos = flat.indexOf @content._id
			if pos > 0
				return Meteor.DB.Contents.findOne(flat[pos - 1])
			else return null
			
	events: null 


function flattenTree tree, fn
	array = []
	for i, item of tree
		if item.published
			if fn? => array.push fn(item)
			else array.push item
			if item.children
				array ++= flattenTree item.children, fn
	return array

function compileTemplate name, markup
	try
		compiled = SpacebarsCompiler.compile markup, {+isTemplate}
		renderer = eval compiled
		UI.Template.__define__(name, renderer);
		return renderer
	catch err
		msg = "Error rendering page: #{err.message}"
		console.info msg
		return msg


