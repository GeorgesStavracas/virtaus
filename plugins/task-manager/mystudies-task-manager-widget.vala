/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * mystudies-task-manager-widget.c
 * Copyright (C) 2013 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
 * 
 * MyStudies is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * MyStudies is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gee;
using MyStudies;
using MyStudies.Core;

[GtkTemplate (ui = "/apps/mystudies/tasks/resources/widget.ui")]
public class MyStudies.Plugins.TaskManager.Widget : Gtk.Frame {
	
	[GtkChild]
	private Gtk.Button reveal_button;
	[GtkChild]
	private Gtk.Revealer revealer;
	[GtkChild]
	private Gtk.ListBox lists;
	[GtkChild]
	private Gtk.ListBox tasks_list;
	[GtkChild]
	private Gtk.Image reveal_button_img;
	
	public Gtk.Button new_task_button;
	private Gee.LinkedList<Core.Task> task_list;
	private TaskManager.EditPanel edit;
	private Core.DatabaseManager db;
	private bool first = true;
	
    public Widget () {
    	lists.set_size_request(300, 300);
    	tasks_list.set_size_request(450, 300);
    	
    	db = Core.DatabaseManager.get_instance();
		
		edit = new EditPanel();
		revealer.add(edit);
		
		edit.task_removed.connect(()=>{
			// hide
			reveal_button.visible = false;
			revealer.reveal_child = false;
			
			edit.set_edit_row(null);
			
			this.load_lists();
		});
		
		edit.task_updated.connect(()=>{
			// hide
			reveal_button.visible = false;
			revealer.reveal_child = false;
			
			edit.set_edit_row(null);
			
			this.load_lists();
		});
		
		tasks_list.row_selected.connect ((row)=>{
			reveal_button.visible = (row != null);
			revealer.reveal_child = true;
			
			reveal_button_img.icon_name = "go-next-symbolic";
			reveal_button.set_image(reveal_button_img);
			
			edit.set_edit_row((row as TaskRow));
		});
		
		// Load lists from default and from database
		this.load_lists();
		this.load_tasks("type = 0", "is_finished = 'false'", null);
		
		lists.row_selected.connect((row)=>{
			// hide
			reveal_button.visible = false;
			revealer.reveal_child = false;
			
			var lrow = row as ListRow;
			this.load_tasks(lrow.condition, lrow.task_condition, lrow.tag_condition);
		});
		
		
		// Exported 'New task' button
		new_task_button = new Gtk.Button.with_label(_("New task"));
		new_task_button.name = "NewTaskButton";
		new_task_button.width_request = 100;
		new_task_button.height_request = 35;
		new_task_button.get_style_context().add_class("suggested-action");
		new_task_button.clicked.connect(()=>{
			var dialog = new NewTaskDialog();
			dialog.modal = true;
			
			// search for the parent window
			Gtk.Widget parent_window = this.parent;
			while (!parent_window.get_type().is_a(typeof(Gtk.Window)))
				parent_window = parent_window.parent;
				
			dialog.set_transient_for(parent_window as Gtk.Window);
			
			dialog.run();
			
			this.load_lists();
		});
		
		db.database_changed.connect(()=>{
			
			// Reload lists
			GLib.SourceFunc func = reload_db;
			GLib.Timeout.add(1000, func);
			
		});
		
		// Setup reveal button
		reveal_button.clicked.connect(()=>{
			// Change the icon according to the state
			if (!revealer.get_child_revealed()) reveal_button_img.icon_name = "go-next-symbolic";
			else reveal_button_img.icon_name = "go-previous-symbolic";
			
			reveal_button.set_image(reveal_button_img);
			
			revealer.set_reveal_child(!revealer.get_child_revealed());
		});
		
		this.show_all();
		
		reveal_button.visible = false;
    }
    
    public void load_lists() {
    	// get the current selected row
    	ListRow selected_row = lists.get_selected_row() as ListRow;
    	int selected_index = 0;
    	string selected_condition = null;
    	string selected_task_condition = null;
    	string selected_tag_condition = null;
    	
    	if (selected_row != null) {
			selected_index = selected_row.get_index();
			selected_condition = selected_row.condition;
			selected_task_condition = selected_row.task_condition;
			selected_tag_condition = selected_row.tag_condition;
    	 }
    	
    	if (first) {
    		selected_index = 0;
    		first = false;
		}
    	
    	// remove all lists
    	foreach (Gtk.Widget w in lists.get_children())
    		lists.remove(w);
    	
    	var datetime = new GLib.DateTime.now_local();
    	var appointments = db.select(new Core.Appointment(), "type = 0", typeof(Core.Appointment));
    	var disciplines = db.select (new Core.Discipline(), null, typeof(Core.Discipline));
    	
    	Gee.LinkedList<Core.BasicType> res;
    	
    	// Default rows for the app
    	var row = new ListRow();
		row.label.label = _("All");
		row.condition = "type = 0 AND id IN (SELECT id FROM Task WHERE is_finished = 'false')";
		row.task_condition = "is_finished = 'false'";
		row.number.label = db.get_n_ocurrences ("Appointment", row.condition, "type").to_string();
		row.show_all();
		lists.add(row);
		if (selected_index == 0) lists.select_row(row);
		
		row = new ListRow();
		row.label.label = _("Overdue");
		row.condition = "type = 0 AND date_appointment < date('now') AND id IN (SELECT id FROM Task WHERE is_finished = 'false')";
		row.task_condition = "is_finished = 'false'";
		row.number.label = db.get_n_ocurrences ("Appointment", row.condition, "type").to_string();
		row.show_all();
		lists.add(row);
		if (selected_index == 1) lists.select_row(row);
		
		row = new ListRow();
		row.label.label = _("Next 7 days");
		row.task_condition = "is_finished = 'false'";
		row.condition = "type = 0 AND date_appointment BETWEEN date('now') and date("
						+ datetime.add_days(7).format("'%Y-%m-%d") + "') AND id IN "
						+ "(SELECT id FROM Task WHERE is_finished = 'false')";
		
		row.number.label = db.get_n_ocurrences ("Appointment", row.condition, "type").to_string();
		row.show_all();
		lists.add(row);
		if (selected_index == 2) lists.select_row(row);
		
		row = new ListRow();
		row.label.label = _("Completed");
		row.condition = "type = 0 AND id IN (SELECT id FROM Task WHERE is_finished = 'true')";
		row.task_condition = "is_finished = 'true'";
		row.number.label = db.get_n_ocurrences ("Appointment", row.condition, "type").to_string();
		row.with_separator = true;
		row.show_all();
		lists.add(row);
		if (selected_index == 3) lists.select_row(row);
		
		edit.disciplines.remove_all();
		
		int counter = 0, discs = 0;
		if (disciplines.size > 0) {
			foreach (Core.BasicType item in disciplines) {
				var d = item as Core.Discipline;
				
				
				// add to the list
				row = new ListRow();
				row.label.label = d.name;
				row.condition = "discipline = "+item.id.to_string()+" AND type=0 AND id IN "
							  + "(SELECT id FROM Task WHERE is_finished = 'false')";
				row.show_all();
				
				
				// get the number of tasks
				row.number.label = db.get_n_ocurrences ("Appointment", row.condition, "type").to_string();
				
				if (counter == disciplines.size - 1) row.with_separator = true;
				
				lists.add(row);
				if (selected_index == counter + 4) lists.select_row(row);
				
				edit.disciplines.append(d.id.to_string(), d.name);
			
				counter++;
				discs++;
			}
		}
		
		var tags = db.select (new Core.Tag(), null, typeof (Core.Tag));
		
		foreach (Core.BasicType t in tags) {
			Core.Tag tag = t as Core.Tag;
			
			// add to the list
				row = new ListRow();
				row.label.use_markup = true;
				row.label.label = "<span foreground=\"%s\"><b>%s</b></span>".printf(tag.color, tag.name);
				row.task_condition = "is_finished = 'false'";
				row.tag_condition = "AppointmentTag.tag = "+tag.get("id")
							  +" AND Appointment.type = 0 AND AppointmentTag.appointment = Appointment.id AND "
							  + "Appointment.id = Task.id AND Task.is_finished = 'false'";
			    row.condition = "id IN (SELECT Appointment.id FROM AppointmentTag, Appointment, Task WHERE "
			    				+ row.tag_condition + ")";
				row.show_all();
				
				
				string cond = "(SELECT * FROM AppointmentTag, Appointment, Task WHERE " + row.tag_condition 
							  + " GROUP BY AppointmentTag.tag)";
				
				// get the number of tasks
				row.number.label = db.get_n_ocurrences (cond, null, null).to_string();
				
				lists.add(row);
				if (selected_index == counter + discs + 1) lists.select_row(row);
				
				counter++;
			
			
		}
		
		
		this.load_tasks(selected_condition, selected_task_condition, selected_tag_condition);
    }
    
    private void load_tasks (string? condition, string? task_condition, string? tag_condition) {
    	
    	foreach (Gtk.Widget w in tasks_list.get_children())
    		tasks_list.remove(w);
    	
    	Gee.LinkedList<Core.BasicType> tasklist, appointments;
    	tasklist = db.select (new Core.Task(), task_condition, typeof(Core.Task));
    	
    	string cond = condition;
    	
    	if (condition != null) cond += " ORDER BY date(date_appointment) DESC";
    	
    	appointments = db.select(new Core.Appointment(), cond, typeof(Core.Appointment));
    	
    	if (tasklist.size > 0) {
			foreach (Core.BasicType ta in tasklist) {
				Core.Task task = ta as Core.Task;
				
				// search for the corresponding appointment
				Core.Appointment app = null;
				foreach (Core.BasicType appoint in appointments) {
					
					if ((appoint as Core.Appointment).id == ta.id) app = appoint as Core.Appointment;
				}
				
				if (app == null) continue;
				
				appointments.remove(app);
				
				task.appointment = app;
				
				// Test task
				TaskRow t = new TaskRow(this);
				t.set_task(task);
				tasks_list.add(t);
				
			}
		}
		
    }
    
    internal Gtk.Widget get_home_row () {
    	Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
    	box.margin = 10;
    	
    	Gtk.Label name = new Gtk.Label(_("<span stretch=\"condensed\" size=\"large\"><b>Tasks</b></span>"));
    	name.xalign = 0.0f;
    	name.use_markup = true;
    	
    	box.pack_start(name);
    	
    	int n_today = db.get_n_ocurrences ("Appointment", "type = 0 AND date(date_appointment) = date('now')", "type");
    	Gtk.Label today_label = new Gtk.Label(null);
    	today_label.xalign = 0.0f;
    	today_label.margin_left = 20;
    	today_label.use_markup = true;
    	
    	if (n_today == 1) today_label.label = _("<b>%d</b> task for today").printf (n_today);
    	else today_label.label = _("<b>%d</b> tasks for today").printf (n_today);
    	
    	
    	box.pack_start(today_label);
    	
    	
    	int n_overdue = db.get_n_ocurrences ("Appointment", "type = 0 AND date_appointment < date('now')", "type");
    	Gtk.Label overdue_label = new Gtk.Label(null);
    	overdue_label.xalign = 0.0f;
    	overdue_label.margin_left = 20;
    	overdue_label.use_markup = true;
    	
    	if (n_overdue == 1) overdue_label.label = _("<b>%d</b> task late").printf (n_today);
    	else overdue_label.label = _("<b>%d</b> tasks late").printf (n_today);
    	
    	box.pack_start(overdue_label);
    	
    	return box;
    	
    }
    
    // Workaround to sync database and plugin
    private bool reload_db() {
    	this.load_lists();
    	return false;
    }
    
}
