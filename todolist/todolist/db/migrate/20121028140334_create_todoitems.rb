class CreateTodoitems < ActiveRecord::Migration
  def up
	create_table 'todoitems' do |t|
		t.string 'title'
		t.datetime 'start_time'
		t.datetime 'time_finished', :null => true
		t.text 'description'
		t.boolean 'done'
		t.integer 'sort_num'
		t.integer 'priority'
		t.timestamps
	end	
  end

  def down
	drop_table 'todoitems'
  end
end