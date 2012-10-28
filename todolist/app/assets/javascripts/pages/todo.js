var current=1;
$(document).ready(function () {

    $("#msgSuccess").hide();
    $("#msgError").hide();
    //C-Create
    $(document).on("click", '#new_todo', function (e) {
        var start_time = new Date();
        $('#modalTodo').modal('show').load("/todoitem/create/", { start_time: start_time.toJSON() });
    });
    //R-Read
    $(document).on("click", '.todo_details', function (e) {
        var id = $(this).closest("li").attr("id");
        $('#modalTodo').modal('show').load("/todoitem/details/" + id);
    });
    //U-Update
    $(document).on("click", '.edit_todo', function (e) {
        var id = $(this).closest("li").attr("id");
        $('#modalTodo').modal('show').load("/todoitem/edit/" + id);
    });

    $(document).on("click", '.finish_todo', function (e) {
        var r = confirm('Are you sure you want check this task as finished? Checking will remove it from the list', 'Check finish?');
        if (r == true) {
            var id = $(this).closest("li").attr("id");
            $.post("/todoitem/finish/" + id,
                        function (data) {
                            RefreshList(data);
                        });
        }
    });
    //D-Delete
    $(document).on("click", '#delete_todo', function (e) {
        var r = confirm('Are you sure you want to delete this task?', 'Delete task?');
        if (r == true) {
            var id = $(this).attr("todoid");
            $.post("/todoitem/delete/" + id,
                        function (data) {
                            RefreshEvents(data);
                        });
        }
    });

    //Submit changes
    $(document).on("click", '#submit_todo', function (e) {
		var id = jQuery("#id").val();
		var user = jQuery("#user").val();
        var title = jQuery("#title").val();
        var start_time = jQuery("#start_time").val();
        var end_time = jQuery("#end_time").val();
        var priority = jQuery("#priority").val();
        var description = jQuery("#description").val();
		var done = jQuery("#done").val();
		var sort_num = jQuery("#sort_num").val();
        jQuery.ajax({
            type: "POST",
            url: "/todoitem/save/",
            data: { 'id': id, 'user': user, 'title': title, 'start_time': start_time, 'end_time': end_time, 'priority': priority, 'description': description, 'done': done, 'sort_num': sort_num },
            traditional: true,
            success: function (data) {
                RefreshEvents(data);
            }
        });
    });

    //Save new order of task list
    $(document).on("click", '#submit-list', function (e) {
		var data = $("#sortable").sortable('toArray');
		var send = data+"";
        $.ajax({
            url: '/todoitem/sorttodos/',
            data: { items: send },
            type: 'post',
            traditional: true,
            success: function (data) {
                RefreshList(data);
            }
        });
    });

    //Lazy loading more tasks in list
    $(document).on("click", '#todo_more', function (e) {
        ++current;
        if ($("#view_archive").attr("id") == "view_archive") {
            $("#todo_list").load("/todoitem/gettodos/"+current, function () {
                $("#sortable").sortable({ axis: "y" });
            });
        } else {
            $("#todo_list").load("/todoitem/getarchive/"+current);
        }
    });

    //Show archived or ongoing list
    $(document).on("click", '#view_archive', function (e) {
        $(this).attr("id", "view_active");
        $(this).text("(View active list)");
		current=1
        $("#todo_list").load("/todoitem/getarchive/"+current);
    });
    $(document).on("click", '#view_active', function (e) {
        $(this).attr("id", "view_archive");
        $(this).text("(View archived list)");
		current=1
        $("#todo_list").load("/todoitem/gettodos/"+current, function () {
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
        eventClick: function (calEvent, jsEvent, view) {
            $('#modalTodo').modal('show').load("/todoitem/edit/" + calEvent.id);

        },
        select: function (start) {
            $('#modalTodo').modal('show').load("/todoitem/create/", { start_time: start.toJSON() });
        }
    });

    //Load todo list
    $("#todo_list").load("/todoitem/gettodos/"+current, function () {
        $("#sortable").sortable({ axis: "y" });
    });

});

function RefreshEvents(data) {
    $('#modalTodo').modal('hide');
    $('#calendar').fullCalendar('refetchEvents');
    RefreshList(data);    
}

function RefreshList(data) {
    if (!data.Success) {
        $("#msgError p").text(data.Msg);
        $("#msgError").show().delay(3000).fadeOut();
    } else {
        $("#msgSuccess p").text(data.Msg);
        $("#msgSuccess").show().delay(3000).fadeOut();       
    }
	$("#todo_list").load("/todoitem/gettodos/"+current, function () {
		$("#sortable").sortable({ axis: "y" });
	});
}