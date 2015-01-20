Meteor.DB = {}


# USERS

Meteor.DB.Users = Meteor.users


# COURSES

Meteor.DB.Courses = new Meteor.Collection 'courses'

Meteor.DB.Courses.hookOptions.after.update = {fetchPrevious: false}

Meteor.DB.Courses.before.insert (userId, doc) ->
	doc.authors = [userId]
	doc.slug = slugify("#{doc.code}-#{doc.name}")
	doc.tags = tagify(doc.tags)
	doc.created = new Date()
	doc.updated = new Date()
	doc.published = false
	doc.views = 0
	doc.contents = []

Meteor.DB.Courses.before.update (userId, doc, fieldNames, modifier) ->
	modifier.$set = modifier.$set || {};
	modifier.$set.updated = new Date()


# COURSE CONTENTS

Meteor.DB.Contents = new Meteor.Collection 'contents'

Meteor.DB.Contents.hookOptions.after.update = {fetchPrevious: false}

Meteor.DB.Contents.before.insert (userId, doc) ->
	doc.authors = [userId]
	doc.slug = slugify("#{doc.title}")
	doc.tags = tagify(doc.tags)
	doc.created = new Date()
	doc.updated = new Date()
	doc.views = 0
	
Meteor.DB.Contents.after.insert (userId, doc) ->
	if Meteor.isServer
		Meteor.DB.Courses.update doc.course, {
			$push: contents: {doc._id, doc.title, doc.slug, published: false}
		}
		
Meteor.DB.Contents.before.update (userId, doc, fieldNames, modifier) ->
	modifier.$set = modifier.$set || {};
	if modifier.$set.tags => modifier.$set.tags = tagify(modifier.$set.tags)
	if modifier.$set.title => modifier.$set.slug = slugify(modifier.$set.title)
	
Meteor.DB.Contents.after.update (userId, doc) ->
	#sorry, this is nasty full data scan.
	if Meteor.isServer
		Meteor.DB.Courses.find().forEach (course) ->
			if updateContents course.contents, doc
				Meteor.DB.Courses.update(course._id, {$set: {course.contents}})
				
	function updateContents contents, content
		updated = false
		contents.forEach (item) ->
			if item._id is content._id
				item.title = content.title
				item.slug = content.slug
				updated := true
			if item.children?.length
				updated := updateContents(item.children, content) || updated
		return updated

# Helper functions

function tagify tags
	if typeof! tags == 'Array' then return tags
	if typeof! tags == 'String' then return tags.split(',').map (.replace /\s/g, '')
	else return []

function slugify text
	text.toLowerCase().replace(/ /g,'-').replace(/[-]+/g, '-').replace(/[^\w-]+/g,'')




