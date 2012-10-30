/*global document: false, confirm: false, $, jQuery */
var refreshList, refreshEvents, current;
current = 1;
refreshList = function (data) {
    "use strict";
    if (!data.Success) {
        $("#msgError p").text(data.Msg);
        $("#msgError").show().delay(3000).fadeOut();
    } else {
        $("#msgSuccess p").text(data.Msg);
        $("#msgSuccess").show().delay(3000).fadeOut();
    }
	$("#todo_list").load("/todoitem/gettodos/" + current, function () {
		$("#sortable").sortable({ axis: "y" });
	});
};

refreshEvents = function (data) {
    "use strict";
    $('#modalTodo').modal('hide');
    $('#calendar').fullCalendar('refetchEvents');
    refreshList(data);
};

$(document).ready(function () {
	"use strict";
    $.ajaxSetup({
        cache: false
    });
    $("#msgSuccess").hide();
    $("#msgError").hide();
    //C-Create
    $(document).on("click", '#new_todo', function () {
        var start_time = new Date();
        $('#modalTodo').modal('show').load("/todoitem/create/", { start_time: start_time.toJSON() });
    });
    //R-Read
    $(document).on("click", '.todo_details', function () {
        var id = $(this).closest("li").attr("id");
        $('#modalTodo').modal('show').load("/todoitem/details/" + id);
    });
    //U-Update
    $(document).on("click", '.edit_todo', function () {
        var id = $(this).closest("li").attr("id");
        $('#modalTodo').modal('show').load("/todoitem/edit/" + id);
    });

    $(document).on("click", '.finish_todo', function () {
        var r, id;
        r = confirm('Are you sure you want check this task as finished? Checking will remove it from active list and put it in archive.', 'Check finish?');
        if (r === true) {
            id = $(this).closest("li").attr("id");
            $.post("/todoitem/finish/" + id,
                        function (data) {
                    refreshList(data);
                });
        }
    });
    //D-Delete
    $(document).on("click", '#delete_todo', function () {
        var r, id;
        r = confirm('Are you sure you want to delete this task?', 'Delete task?');
        if (r === true) {
            id = $(this).attr("todoid");
            $.post("/todoitem/delete/" + id,
                        function (data) {
                    refreshEvents(data);
                });
        }
    });

    //Submit changes
    $(document).on("click", '#submit_todo', function () {
        var id, user, title, start_time, end_time, priority, description, done, sort_num;
	    id = jQuery("#id").val();
	    user = jQuery("#user").val();
        title = jQuery("#title").val();
        start_time = jQuery("#start_time").val();
        end_time = jQuery("#end_time").val();
        priority = jQuery("#priority").val();
        description = jQuery("#description").val();
	    done = jQuery("#done").val();
	    sort_num = jQuery("#sort_num").val();
        jQuery.ajax({
            type: "POST",
            url: "/todoitem/save/",
            data: { 'id': id, 'user': user, 'title': title, 'start_time': start_time, 'end_time': end_time, 'priority': priority, 'description': description, 'done': done, 'sort_num': sort_num },
            traditional: true,
            success: function (data) {
                refreshEvents(data);
            }
        });
    });

    //Save new order of task list
    $(document).on("click", '#submit-list', function () {
        var data, send;
		data = $("#sortable").sortable('toArray');
		send = String(data);
        $.ajax({
            url: '/todoitem/sorttodos/',
            data: { items: send },
            type: 'post',
            traditional: true,
            success: function (data) {
                refreshList(data);
            }
        });
    });

    //Lazy loading more tasks in list
    $(document).on("click", '#todo_more', function () {
        current += 1;
        if ($("#view_archive").attr("id") === "view_archive") {
            $("#todo_list").load("/todoitem/gettodos/" + current, function () {
                $("#sortable").sortable({ axis: "y" });
            });
        } else {
            $("#todo_list").load("/todoitem/getarchive/" + current);
        }
    });

    //Show archived or ongoing list
    $(document).on("click", '#view_archive', function () {
        $(this).attr("id", "view_active");
        $(this).text("(View active list)");
		current = 1;
        $("#todo_list").load("/todoitem/getarchive/" + current);
    });
    $(document).on("click", '#view_active', function () {
        $(this).attr("id", "view_archive");
        $(this).text("(View archived list)");
		current = 1;
        $("#todo_list").load("/todoitem/gettodos/" + current, function () {
            $("#sortable").sortable({ axis: "y" });
        });
    });

    //Show and configure fullcalendar.js
    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        allDayDefault: false,
        selectable: true,
        selectHelper: true,
        events: "/todoitem/getcalendarevents/",
        eventClick: function (calEvent) {
            $('#modalTodo').modal('show').load("/todoitem/edit/" + calEvent.id);

        },
        select: function (start) {
            $('#modalTodo').modal('show').load("/todoitem/create/", { start_time: start.toJSON() });
        }
    });

    //Load todo list
    $("#todo_list").load("/todoitem/gettodos/" + current, function () {
        $("#sortable").sortable({ axis: "y" });
    });
});