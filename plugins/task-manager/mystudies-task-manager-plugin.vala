/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * mystudies-events-plugin.c
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

internal class MyStudies.Plugins.TaskManager.Main : Gtk.Bin, MyStudies.Core.Plugin {
	
	public TaskManager.Widget widget;
	
	public string get_name() {
		return _("Tasks");
	}
	
	public void registered(MyStudies.Core.PluginLoader loader) {
		
	}
	
	public void activated() {
		this.widget = new TaskManager.Widget();
		
		
		var provider = new Gtk.CssProvider ();
		try {
			var file = File.new_for_uri("resource:///apps/mystudies/tasks/resources/style.css");
		    //var file = File.new_for_path("/mnt/Data/Projetos/Faculdade/BD/Aplicativo/MyStudies/plugins/task-manager/resources/style.css");
		    // apply css to the screen
			Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), 
													  provider,
		                                              Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
		    provider.load_from_file(file);
		} catch (Error e) {
		    stderr.printf ("loading css: %s\n", e.message);
		}
	}
    
    public void deactivated() {
    	message("destroyed");
    }
    
    public Gtk.Widget? get_view() {
    	return this.widget;
    }
    
    public Gtk.Widget? get_listbox_row() {
    	return widget.get_home_row();
    }
    
    public Gtk.Widget? get_button() {
    	return this.widget.new_task_button;
    }
    
    public Gtk.Menu? get_menu() {
    	return null;
    }
    
}


[ModuleInit]
public Type plugin_init (TypeModule module) {
    return typeof(MyStudies.Plugins.TaskManager.Main);
}
