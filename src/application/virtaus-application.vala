/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-application.c
 * Copyright (C) 2013 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
 * 
 * Virtaus is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Virtaus is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class Virtaus.Application : Gtk.Application 
{

	private Virtaus.Window window;
	
	public Cream.Context context {get; construct;}

	public Application () {
    Object (application_id: "apps.virtaus",
            flags: GLib.ApplicationFlags.FLAGS_NONE,
            context: new Cream.Context ());

	  context.plugin_manager.add_plugin_search_path (Config.PLUGINDIR, null);
	}
	
	protected override void activate ()
		{		
        // Create the window of this application and show it
				if (window == null)
						window = new Virtaus.Window(this);

				window.present();
		}
	
	protected override void startup()
	{
	  Gtk.CssProvider provider;

		base.startup();

		provider = new Gtk.CssProvider ();

		try
		{
		  GLib.File file;
		  Gtk.Builder builder;

			file = File.new_for_uri("resource:///apps/virtaus/resources/style.css");

	    // apply css to the screen
			Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), 
																							  provider,
	                                              Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
	    provider.load_from_file(file);

	    /* load appmenu from menu file */
	    builder = new Gtk.Builder.from_resource ("/apps/virtaus/resources/menu.ui");
	    this.app_menu = builder.get_object ("appmenu") as GLib.MenuModel;
		}

		catch (Error e)
		{
		    stderr.printf ("loading css: %s\n", e.message);
		}

		var quit_action = new SimpleAction ("quit", null);
		this.add_action (quit_action);

		quit_action.activate.connect (()=>
		{
		  this.window.destroy ();
	  });
	}
}


