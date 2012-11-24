# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
current = 1
refreshList = (data) ->
  unless data.Success
    $("#msgError p").text data.Msg
    $("#msgError").show().delay(3000).fadeOut()
  else
    $("#msgSuccess p").text data.Msg
    $("#msgSuccess").show().delay(3000).fadeOut()
  $("#todo_list").load "/todoitem/gettodos/" + current, ->
    $("#sortable").sortable axis: "y"
	
refreshEvents = (data) ->
  $("#modalTodo").modal "hide"
  $("#calendar").fullCalendar "refetchEvents"
  refreshList data

$(document).ready ->
  $.ajaxSetup cache: false
  $("#msgSuccess").hide()
  $("#msgError").hide()
  
  #C-Create
  $(document).on "click", "#new_todo", ->
    start_time = new Date()
    $("#modalTodo").modal("show").load "/todoitem/create/",
      start_time: start_time.toJSON()
  
  #R-Read
  $(document).on "click", ".todo_details", ->
    id = $(this).closest("li").attr("id")
    $("#modalTodo").modal("show").load "/todoitem/details/" + id
  
  #U-Update
  $(document).on "click", ".edit_todo", ->
    id = $(this).closest("li").attr("id")
    $("#modalTodo").modal("show").load "/todoitem/edit/" + id

  $(document).on "click", ".finish_todo", ->
    r = confirm("Are you sure you want check this task as finished? Checking" +
    " will remove it from active list and put it in archive.", "Check finish?")
    if r is true
      id = $(this).closest("li").attr("id")
      $.post "/todoitem/finish/" + id, (data) ->
        refreshList data
  
  #D-Delete
  $(document).on "click", "#delete_todo", ->
    r = confirm("Are you sure you want to delete this task?", "Delete task?")
    if r is true
      id = $(this).attr("todoid")
      $.post "/todoitem/delete/" + id, (data) ->
        refreshEvents data
  
  #Submit changes
  $(document).on "click", "#submit_todo", ->
    id = $("#id").val()
    user = $("#user").val()
    title = $("#title").val()
    start_time = $("#start_time").val()
    end_time = $("#end_time").val()
    priority = $("#priority").val()
    description = $("#description").val()
    done = $("#done").val()
    sort_num = jQuery("#sort_num").val()
    jQuery.ajax
      type: "POST"
      url: "/todoitem/save/"
      data:
        id: id
        user: user
        title: title
        start_time: start_time
        end_time: end_time
        priority: priority
        description: description
        done: done
        sort_num: sort_num
      traditional: true
      success: (data) ->
        refreshEvents data
  
  #Save new time zone
  $(document).on "click", "#change_time_zone", ->
    zone = $("#user_time_zone").val()
    $.ajax
      url: "/todoitem/changezone/"
      data:
        zone: zone
      type: "post"
      success: (data) ->
        $("#calendar").fullCalendar "refetchEvents"
		#Setting to active view if it's not already set
        archive = $("#view_active")
        $(archive).attr "id", "view_archive"
        $(archive).text "(View archived list)"
        current = 1
        refreshList data
  
  #Save new order of task list
  $(document).on "click", "#submit-list", ->
    data = $("#sortable").sortable("toArray")
    send = String(data)
    $.ajax
      url: "/todoitem/sorttodos/"
      data:
        items: send
      type: "post"
      traditional: true
      success: (data) ->
        refreshList data
  
  #Lazy loading more tasks in list
  $(document).on "click", "#todo_more", ->
    current += 1
    if $("#view_archive").attr("id") is "view_archive"
      $("#todo_list").load "/todoitem/gettodos/" + current, ->
        $("#sortable").sortable axis: "y"
    else
      $("#todo_list").load "/todoitem/getarchive/" + current

  
  #Show archived or ongoing list
  $(document).on "click", "#view_archive", ->
    $(this).attr "id", "view_active"
    $(this).text "(View active list)"
    current = 1
    $("#todo_list").load "/todoitem/getarchive/" + current

  $(document).on "click", "#view_active", ->
    $(this).attr "id", "view_archive"
    $(this).text "(View archived list)"
    current = 1
    $("#todo_list").load "/todoitem/gettodos/" + current, ->
      $("#sortable").sortable axis: "y"
  
  #Show and configure fullcalendar.js
  $("#calendar").fullCalendar
    header:
      left: "prev,next today"
      center: "title"
      right: "month,agendaWeek,agendaDay"
    allDayDefault: false
    selectable: true
    selectHelper: true
    events: "/todoitem/getcalendarevents/"
    eventClick: (calEvent) ->
      $("#modalTodo").modal("show").load "/todoitem/edit/" + calEvent.id
    select: (start) ->
      $("#modalTodo").modal("show").load "/todoitem/create/",
        start_time: start.toJSON()
  
  #Load todo list
  $("#todo_list").load "/todoitem/gettodos/" + current, ->
    $("#sortable").sortable axis: "y"