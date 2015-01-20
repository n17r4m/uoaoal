
Router.route '/manage/:_id',
	waitOn: -> Meteor.subscribe('courses')
	action: -> @render 'Manage',
		data: -> Meteor.DB.Courses.findOne @params._id



Planet("Manage") do
	rendered: ->
		Session.setDefault('Manage.show', null)

	helpers:
		showing: (str) -> Session.equals('Manage.show', str)
		test: (a, b, c) ->
			console.info @, a, b, c
	
	events:
		'click .add.button': (e) -> Session.set('Manage.show', 'add')
		'click .link.button': (e) -> Session.set('Manage.show', 'link')
		'click .cancel.button': (e) -> Session.set('Manage.show', null); false
		
		'change .nestable': (e, t) ->
			
			course = t.data._id
			nest = $(e.currentTarget)
			
			changedId = nest.find(".changed").data('_id')
			contents = nest.nestable('serialize')
			
			startPath = pathForNestedId t.data.contents, changedId
			endPath = pathForNestedId contents, changedId
			
			Meteor.DB.Courses.update course, {$set: {contents}}, ->
				# to keep nestable and meteor from fighting, if there 
				# has been a change in tree structure, we need to 
				# manually remove the changed element, as meteor
				# adds a new one in.
				if startPath isnt endPath 
					nest.find(".changed").remove()
		
		'click .publish.button': (e, t) ->
			course = t.data._id
			contents = t.data.contents
			_id = $(e.target).parent().data('_id')
			item = findNestedItemById contents, _id
			item.published = not item.published
			Meteor.DB.Courses.update course, {$set: {contents}}
		
		'click .edit.button': (e, t) ->
			Session.set("Manage.show", 'edit')
			Meteor.setTimeout -> # need to wait for next tick (when form has rendered)
				form = $(t.lastNode).parent().find(".edit.form")
				_id = $(e.target).parent().data('_id')
				content = Meteor.DB.Contents.findOne(_id)
				console.info content
				form.find('input[name=_id]').val(content._id)
				form.find('input[name=title]').val(content.title)
				form.find('input[name=tags]').val(content.tags)
				form.find('textarea[name=content]').val(content.content)
		
		'click .view.button': (e, t) ->
			course = t.data
			itemEl = $(e.target).parent()
			_id = itemEl.data('_id')
			slug = itemEl.data('slug')
			open("/course/#{course._id}/#{course.slug}/#{_id}/#{slug}")
		
		'submit .add.form': (e, t) ->
			form = $(e.currentTarget)
			
			title = form.find('input[name=title]').val()
			tags = form.find('input[name=tags]').val()
			content = form.find('textarea[name=content]').val()
			course = t.data._id # current course id
			
			Meteor.DB.Contents.insert({title, course, tags, content})
			
			form[0].reset()
			Session.set('Manage.show', null)
			return false
		
		'submit .edit.form': (e, t) ->
			form = $(e.currentTarget)
			
			_id = form.find('input[name=_id]').val()
			title = form.find('input[name=title]').val()
			tags = form.find('input[name=tags]').val()
			content = form.find('textarea[name=content]').val()
			
			Meteor.DB.Contents.update(_id, {$set: {title, tags, content}})
			
			form[0].reset()
			Session.set('Manage.show', null)
			return false

function findNestedItemById tree, _id
	function search tree, _id
		for i, item of tree
			if item._id is _id
				return item
			else
				if item.children
					item = search item.children, _id
					if item?
						return item
		return false
	return search tree, _id


function pathForNestedId tree, _id
	function search tree, _id, path
		for i, item of tree
			if item._id is _id
				return path
			else
				if item.children
					subpath = search item.children, _id, path.concat(i)
					if subpath?
						return subpath
		return false
	path = search(tree, _id, [])
	if path => return path.join(",")
	else return false

