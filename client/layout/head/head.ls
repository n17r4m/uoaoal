defaultTitle = "UofA Open Access Learning"

# Handle page title changes
Session.setDefault("Title", defaultTitle);
Tracker.autorun -> document.title = "#{Session.get('Title')}";

# Update page title via: Session.set('Title', "The new page title")
# or, using the UI helper {{Title 'The new page title'}}:

UI.registerHelper "Title", (title = defaultTitle) !->
	Session.set 'Title', title
