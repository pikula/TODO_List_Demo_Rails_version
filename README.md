TODO_List_Demo_Rails_version
============================
Basic TODO List Demonstration application.

Functionalities:
- multi-user system with registration and email confirmation
- adding, editing, viewing, archiving and deleting tasks
- tasks prioritised in 3 levels: high, medium, low
- user enabled sorting of tasks with drag and drop functionalities (exception: newly added tasks always show on top of preferred user order or default order, default ordering: highest priority first then start time)
- view of archived (done) and active tasks
- show more button on TODO List (default view shows 20 tasks)
- Ajax loading of changes on page
- user enabled time zone change (default time zone: "Zagreb", added: 2/11/2012)

Technologies used: 
- Twitter Bootstrap (http://twitter.github.com/bootstrap/)
- FullCalendar jQuery plugin (http://arshaw.com/fullcalendar/)
- jQuery (http://jquery.com/)
- CSS
- CofeeScript (http://coffeescript.org/)
- Ruby on Rails (http://railsinstaller.org/ - Windows installer version 2.1.0):
	* Ruby 1.9.3-p125
	* Rails 3.2
	* Bundler 1.0.18
	* Sqlite 3.7.3
	* TinyTDS 0.4.5
	* SQL Server support 3.3.3
	* DevKit
- added gems:
	* Haml (http://haml.info/)
	* Devise (https://github.com/plataformatec/devise)
	

Tested with: 
- Google Chrome version 22.0.1229.94
- Firefox version 16.0.2.
- Opera version 12.02
- Internet Explorer version 9.0.8112.16421
- Safari version 5.1.7

Fixed bugs:
- In Internet Explorer popup dialogs do not work correctly. They show up, but they disappear with click within a browser so forms cannot be filled. (fix date: 30/10/2012)
- Time shows up in UTC format. (fix date: 2/11/2012)

Preview of app:
 - default view: http://oi50.tinypic.com/fegqk3.jpg
 - edit task: http://oi45.tinypic.com/dlnfrn.jpg
 - task details: http://oi48.tinypic.com/2n7nzn4.jpg
 - archived tasks view: http://oi46.tinypic.com/x3y1e1.jpg