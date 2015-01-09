/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * mystudies-task-manager-list-row.c
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

[GtkTemplate (ui = "/apps/mystudies/tasks/resources/list_row.ui")]
public class MyStudies.Plugins.TaskManager.ListRow : Gtk.ListBoxRow {
	
	[GtkChild]
	public Gtk.Label label;
	[GtkChild]
	public Gtk.Label number;
	
	public string? condition {get; set; default = "type = 0";}
	public string? task_condition {get; set; default = null;}
	public string? tag_condition {get; set; default = null;}
	
	private bool separator = false;
	public bool with_separator {
		get {return separator; }
		set {
			separator = value;
			var style = this.get_style_context();
			if (separator) style.add_class("row-separator");
			else style.remove_class("row-separator");
			}
		}
}
