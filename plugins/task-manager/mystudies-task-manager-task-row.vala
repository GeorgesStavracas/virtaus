/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * mystudies-task-manager-task-row.c
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
using Gtk;

[GtkTemplate (ui = "/apps/mystudies/tasks/resources/task_row.ui")]
internal class MyStudies.Plugins.TaskManager.TaskRow : Gtk.ListBoxRow {
	
	public signal void task_changed (Core.Task task);
	
	[GtkChild]
	public Gtk.CheckButton check;
	[GtkChild]
	public Gtk.Label task_label;
	[GtkChild]
	public Gtk.Label date_label;
	
	private TaskManager.Widget parent_widget;
	private Core.Task? task = null;
	private bool check_task = false;
	
	public TaskRow(TaskManager.Widget parent) {
		
		this.parent_widget = parent;
		
		check.toggled.connect(()=>{
			// Control to not run this signal's callback
			// when marking the task as finished
			// at construction time
			if (check_task) return;
			
			task.finished = check.active;
			task.update("is_finished");
			this.visible = false;
			parent_widget.load_lists();
		});
	}
	
	public void set_task(Core.Task task) {
		task_label.label = task.appointment.name;
		date_label.label = task.appointment.datetime.format(_("%d/%m/%Y"));
		
		if (task.finished) {
			check_task = true;
			check.set_active(task.finished);
			check_task = false;
		}
		
		this.task = task;
		this.show_all();
	}
	
	public Core.Task? get_task() {
		return task;
	}
}
