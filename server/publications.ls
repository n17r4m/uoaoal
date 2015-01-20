Meteor.publish "courses", -> Meteor.DB.Courses.find();
Meteor.publish "contents", -> Meteor.DB.Contents.find();
