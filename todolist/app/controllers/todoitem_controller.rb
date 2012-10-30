class TodoitemController < ApplicationController

  TODOS_PER_SECTION = 20
  before_filter :authenticate_user!
 
  def index
  end
  
  def create
	@todo = Todoitem. new
	@todo.start_time=params[:start_time].to_time
	render :partial => "/todoitem/todoform"
  end
  
  def edit
	@todo = Todoitem.find_by_id(params[:id])
	if(@todo.nil?)
		@todo=Todoitem. new
		@todo.start_time=DateTime.now
	end
	if(@todo.done)
		render :partial => "/todoitem/tododetails"
	else
		render :partial => "/todoitem/todoform"
	end
  end
  
  def finish
	@todo = Todoitem.find_by_id(params[:id])
	if(@todo.nil?)
		result={:Success=>false, :Msg=>"You selected a non existent item." }
		return render :json => result.to_json		
	end
	@todo.update_attributes!(:done=>true, :time_finished=>DateTime.now)
	result={:Success=>true, :Msg=>"Task was succesfully noted as done."}
	render :json => result.to_json		
  end
  
  def details
	@todo = Todoitem.find_by_id(params[:id])
	if(@todo.nil?)
		@todo=Todoitem. new
		@todo.start_time=DateTime.now	
		render :partial => "/todoitem/todoform"
	else
		render :partial => "/todoitem/tododetails"
	end
  end
  
  def save	
	message =""
	title=params[:title]
	start_time=params[:start_time].to_time
	if(title.empty? || start_time.nil?)
		result={:Success=>false, :Msg=>"You have entered invalid data in the form! Title and date must not be empty! Date must be in datetime format example dd/mm/yyyy hh:mm"}
		return render :json => result.to_json	
	end
	if params[:id]==""
		message="Task was successfully created!"
		Todoitem.create!(:title=>params[:title], :start_time=>params[:start_time].to_time, :time_finished=>nil, :description=>params[:description], :done=>false, :priority=>params[:priority].to_i, :sort_num=>0, :user_id=>current_user.id)
	else
		message="Task was successfully updated."
		@todo = Todoitem.find params[:id].to_i
		@todo.update_attributes!(:title=>params[:title], :start_time=>params[:start_time].to_time, :description=>params[:description], :priority=>params[:priority].to_i)		
	end
	result={:Success=>true, :Msg=>message}
	render :json => result.to_json		
  end
  
  def delete
	@todo = Todoitem.find_by_id(params[:id])
	if(@todo.nil?)
		result={:Success=>false, :Msg=>"You selected a non existent item." }
		return render :json => result.to_json
	end
	@todo.destroy
	message={:Success=>true, :Msg=>"Task was successfully deleted"}
	render :json => message.to_json
  end
  
  def getcalendarevents
	@events=Todoitem.all(:conditions => {:user_id=>current_user.id})
	events = [] 
	@events.each do |event|
      events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.start_time.iso8601}", :end => "#{event.start_time.iso8601}", :className=>event.priority_string}
    end
    render :json => events.to_json
  end
  
  def sorttodos
	order=1
	@items = params[:items].split(',')
	@items.each do |item|
		puts item
		@todo = Todoitem.find item.to_i
		@todo.update_attributes!(:sort_num=>order)
		order=order+1
	end
	message={:Success=>true, :Msg=>"List was successfully sorted but newly created tasks are always showed on top regardless of your preffered order!"}
	render :json => message.to_json
  end
  
  def gettodos
	section=params[:current].to_i
	loaded_todos=TODOS_PER_SECTION*section
	@events=Todoitem.where(:done => false, :user_id=>current_user.id).order("sort_num ASC, priority ASC, start_time ASC").limit(loaded_todos)
	@loaded = @events.count<loaded_todos
	render :partial => "/todoitem/todolist"
  end
  
  def getarchive
	section=params[:current].to_i
	loaded_todos=TODOS_PER_SECTION*section
	@events=Todoitem.where(:done => true, :user_id=>current_user.id).order("time_finished DESC").limit(loaded_todos)
	@loaded = @events.count<loaded_todos	
	@archive=true
	render :partial => "/todoitem/todolist"
  end
end
