/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * mystudies-task-manager-new-task-dialog.c
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

[GtkTemplate (ui = "/apps/mystudies/tasks/resources/new_task_dialog.ui")]
public class MyStudies.Plugins.TaskManager.NewTaskDialog : Gtk.Dialog {

    [GtkChild]
    private Gtk.Button cancel_button;
    [GtkChild]
    private Gtk.Button create_button;
    [GtkChild]
    private Gtk.SpinButton day_spin;
    [GtkChild]
    private Gtk.SpinButton month_spin;
    [GtkChild]
    private Gtk.SpinButton year_spin;
    [GtkChild]
    private Gtk.ComboBoxText disciplines;
    [GtkChild]
    private Gtk.Entry name_entry;
    [GtkChild]
    private Gtk.TextView description_text;
    
    private int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    
    public NewTaskDialog() {
    	
    	var d = new GLib.DateTime.now_local();
    	
    	// setup adjustments
    	var adj = new Gtk.Adjustment(d.get_day_of_month(), 1, 32, 1, 1, 1);
    	day_spin.adjustment = adj;
    	
    	adj = new Gtk.Adjustment(d.get_month(), 1, 13, 1, 1, 1);
    	month_spin.adjustment = adj;
    	
    	adj = new Gtk.Adjustment(d.get_year(), 1, 4000, 1, 1, 1);
    	year_spin.adjustment = adj;
    	
    	// change adjustments according to the current selected date
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
    	
    	name_entry.changed.connect(()=>{
    		create_button.sensitive = content_is_valid();
    	});
    	
    	disciplines.changed.connect(()=>{
    		create_button.sensitive = content_is_valid();
    	});
    	
    	create_button.clicked.connect (()=>{
    		if (content_is_valid())
    			add_task();
    	});
    	
    	cancel_button.clicked.connect(()=>{
    		this.dispose();
    	});
    	
    	
    	
    	// Setup disciplines
    	Core.DatabaseManager db = Core.DatabaseManager.get_instance();
    	var list = db.select(new Core.Discipline(), null, typeof(Core.Discipline));
    	
    	foreach (Core.BasicType i in list)
    		disciplines.append(i.id.to_string(), (i as Core.Discipline).get("name"));
    	
    	if(list.size > 0) disciplines.set_active_id ((list.get(0) as Core.Discipline).id.to_string());
    }
    
    private bool content_is_valid () {
    	if (name_entry.text == "") return false;
    	if (disciplines.get_active_text() == null) return false;
    	if (disciplines.get_active_text() == "") return false;
    	
    	return true;
    }
    
    private void add_task() {
    	
    	var db = Core.DatabaseManager.get_instance();
    	
    	var date = new GLib.DateTime.local ((int) year_spin.value, (int) month_spin.value,
    						(int) day_spin.value, 0, 0, 0);
    	
    	var task = new Core.Task();
    	task.id = db.get_last_id(new Core.Appointment()) + 1;
    	task.appointment.id = task.id;
    	task.appointment.name = name_entry.text;
    	task.appointment.datetime = date;
    	task.description = description_text.buffer.text;
    	task.appointment.discipline = int.parse(disciplines.get_active_id());
    	task.finished = false;
    	task.appointment.apt_type = 0;
    	
    	task.add();
    	
    	this.dispose();
    }
}
