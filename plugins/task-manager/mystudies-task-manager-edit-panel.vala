/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * mystudies-task-manager-edit-panel.c
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

[GtkTemplate (ui = "/apps/mystudies/tasks/resources/edit_panel.ui")]
public class MyStudies.Plugins.TaskManager.EditPanel : Gtk.Frame {
	
	public signal void task_updated();
	public signal void task_removed();
	
	[GtkChild]
	private Gtk.Entry name_entry;
	[GtkChild]
	private Gtk.TextView description_text;
	[GtkChild]
	public Gtk.ComboBoxText disciplines;
	[GtkChild]
	private Gtk.SpinButton day_spin;
	[GtkChild]
	private Gtk.SpinButton month_spin;
	[GtkChild]
	private Gtk.SpinButton year_spin;
	[GtkChild]
	private Gtk.ListBox tags;
	[GtkChild]
	private Gtk.Button delete_task_btn;
	[GtkChild]
	private Gtk.Button finish_task_btn;
	
	private bool update = false;
	public Core.Task task {get; private set;}
	private TaskRow? row;
	private int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
	
	public EditPanel() {
		
		var d = new GLib.DateTime.now_local();
		
		var adj = new Gtk.Adjustment(d.get_day_of_month(), 1, 32, 1, 1, 1);
    	day_spin.adjustment = adj;
    	
    	adj = new Gtk.Adjustment(d.get_month(), 1, 13, 1, 1, 1);
    	month_spin.adjustment = adj;
    	
    	adj = new Gtk.Adjustment(d.get_year(), 1, 4000, 1, 1, 1);
    	year_spin.adjustment = adj;
    	
    	month_spin.changed.connect (()=>{
    		day_spin.adjustment.upper = days[(int) month_spin.value - 1] + 1;
    		if (year_spin.value % 4 == 0 && month_spin.value == 2)
    			day_spin.adjustment.upper = days[(int) month_spin.value - 1] + 2;
			
			if (day_spin.value > day_spin.adjustment.upper - 1)
				day_spin.value = day_spin.adjustment.upper - 1;
    	});
    	
    	year_spin.changed.connect (()=>{
    		if (year_spin.value % 4 == 0 && month_spin.value == 2)
    			day_spin.adjustment.upper = days[(int) month_spin.value - 1] + 2;
			
			if (day_spin.value > day_spin.adjustment.upper - 1)
				day_spin.value = day_spin.adjustment.upper - 1;
    	});
		
		
		name_entry.changed.connect (()=>{
			update = true;
		});
		
		description_text.buffer.changed.connect (()=>{
			update = true;
		});
		
		delete_task_btn.clicked.connect (()=>{
			task.delete();
			
			// check whether the panel is assigned to a row,
			// and remove the row
			if (row != null) {
				row.visible = false;
				var list = row.get_parent() as Gtk.ListBox;
				list.remove (row);
			}
			
			// send signal
			task_removed();
		});
		
		finish_task_btn.clicked.connect (()=>{
			this.update_task();
		});
	}
	
	internal void set_edit_row (TaskRow? row) {
		
		// reset the content
		if (row == null) {
			this.task = null;
			name_entry.text = "";
			description_text.buffer.text = "";
			disciplines.active = -1;
			return;
		}
		
		
		var t = row.get_task();
		this.task = t;
		
		name_entry.text = t.appointment.name;
		description_text.buffer.text = t.description;
		disciplines.set_active_id (t.appointment.discipline.to_string());
		
		var d = t.appointment.datetime;
		
		day_spin.adjustment.value = d.get_day_of_month();
		month_spin.adjustment.value = d.get_month();
		year_spin.adjustment.value = d.get_year();
		
		this.reload_tags();
	}
	
	private bool update_task() {
		if (!update) return true;
		
		var db = Core.DatabaseManager.get_instance();
		
		db.send_events = false;
		
		task.db_ref = "Task";
		
		task.description = description_text.buffer.text;
		task.update("description");
		
		task.appointment.db_ref = "Appointment";
		task.appointment.datetime = new GLib.DateTime.local ((int) year_spin.value, (int) month_spin.value, (int) day_spin.value, 0, 0, 0);
		task.appointment.update("date_appointment");
		
		task.appointment.discipline = int.parse(disciplines.get_active_id());
		task.appointment.update("discipline");
		
		foreach (Gtk.Widget w in tags.get_children()) {
			var row = w as TagRow;
			string r_query = "DELETE FROM AppointmentTag WHERE appointment = "+task.get("id")+" AND tag = "+row.tag.get("id");
			string a_query = "INSERT INTO AppointmentTag (appointment, tag) VALUES (" +task.get("id")+","+row.tag.get("id") + ")";
			
			if (row.selected) db.non_select_command (a_query);
			else db.non_select_command (r_query);
		}
		
		task.appointment.name = name_entry.text;
		task.appointment.update("name");
		
		task.db_ref = "Task";
		
		this.update = false;
		
		// send the update signal
		task_updated();
		
		db.send_events = true;
		db.send_event ("changed");
		
		return true;
	}
	
	private void reload_tags () {
		
		// clean up the list
		foreach (Gtk.Widget w in tags.get_children())
			tags.remove (w);
		
		var db = Core.DatabaseManager.get_instance ();
		
		var taglist = db.select (new Core.Tag(), null, typeof (Core.Tag));
		
		Gee.LinkedList<Core.BasicType> list = null;
		if (task != null)
			list = db.custom_select (typeof (Core.Tag), "SELECT * FROM Tag WHERE id IN "
							+ "(SELECT tag FROM AppointmentTag WHERE appointment = "+task.get("id")+")");
		
		foreach (Core.BasicType b in taglist) {
			Core.Tag tag = b as Core.Tag;
			
			TagRow row = new TagRow(tag);
			
			if (task != null) {
				foreach (Core.BasicType bt in list)
					if (tag.id == bt.id) row.selected = true;
			}
			
			tags.add (row);
		}
		
	}
}

internal class MyStudies.Plugins.TaskManager.TagRow : Gtk.ListBoxRow {

	private Gtk.CheckButton check;
	public Gtk.Label label;
	public Core.Tag tag {get; private set;}
	
	public bool selected {
		get {
			return check.active;
		}
		
		set {
			check.active = value;
		}
	}

	public TagRow (Core.Tag tag) {
		this.tag = tag;
		
		var ctx = this.get_style_context();
		ctx.add_class ("row-separator");
		
		check = new Gtk.CheckButton();
		check.hexpand = false;
		check.vexpand = false;
		
		label = new Gtk.Label(null);
		label.use_markup = true;
		label.label = "<span foreground=\"%s\"><b>%s</b></span>".printf(tag.color, tag.name);
		label.xalign = 0.0f;
		
		
		var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
		var box2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		
		box.hexpand = true;
		box2.hexpand = true;
		
		box.pack_start(check);
		box.pack_start(label);
		
		// filler
		box.pack_start(box2);
		
		this.add (box);
		
		this.show_all();
	}
	
}



