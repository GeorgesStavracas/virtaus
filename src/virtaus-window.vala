/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-window.c
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

namespace Virtaus
{

public enum WindowMode
{
	CREATION,
	NORMAL,
	SELECTION;
}

[GtkTemplate (ui = "/apps/virtaus/resources/window.ui")]
public class Window : Gtk.ApplicationWindow
{
  [GtkChild]
  private Gtk.HeaderBar headerbar;
  [GtkChild]
  public Gtk.Stack stack;
  [GtkChild]
  public Gtk.Popover menu_popover;
  [GtkChild]
  public Gtk.MenuButton menu_button;

  private Virtaus.View.AbstractView[] views;
  private int current_view;

	/**
	 * Signal emitted when an {@link GLib.Object} is selected.
	 */
	public signal void object_selected (Virtaus.Core.DataType type, GLib.Object? object);

  public Window (Virtaus.Application app) {
  	Object(application: app);

  	this.set_titlebar(headerbar);

  	this.set_size_request(800, 600);
  	this.maximize();
  	
  	/* Setup App menu */
  	this.setup_gmenu();
  	
  	try {
  		this.set_icon(new Gdk.Pixbuf.from_resource("/apps/virtaus/resources/icon.png"));
  	} catch (Error e) {
  		warning (_("Error loading icon.\n"));
  	}

  	/* Create Views */
  	current_view = 0;
  	views = new Virtaus.View.AbstractView[2];

  	views[0] = new Virtaus.View.CollectionView (this);
  	views[1] = new Virtaus.View.CategoryView (this);
  	//views[2] = new Virtaus.CollectionView ();

		for (int i = 0; i < views.length; i++)
		{
			Gtk.Widget widget;
			widget = views[i] as Gtk.Widget;

			/* Chain views' signals & place them at the stack */
			stack.add_named (widget, views[i].get_name ());

			views[i].register_widget.connect (on_widget_registered);
			//views[i].register_menu.connect (on_menu_registered);
		}

		activate_view (views[0]);
  }

	public void change_mode (Virtaus.WindowMode mode)
	{
		headerbar.set_title (views[current_view].get_title ());
		if (views[current_view].get_subtitle () != null)
			headerbar.set_subtitle (views[current_view].get_subtitle ());

		switch (mode)
		{
			case Virtaus.WindowMode.CREATION:
				headerbar.show_close_button = false;
				break;

			case Virtaus.WindowMode.NORMAL:
				headerbar.show_close_button = true;
				break;

			case Virtaus.WindowMode.SELECTION:
				headerbar.show_close_button = false;
				break;

			default:
				headerbar.show_close_button = false;
				break;
		}
	}

	private void on_widget_registered (Virtaus.Core.InterfaceLocation location, Gtk.Widget? widget)
	{
		if (widget == null)
			return;

		switch (location)
		{
			case Core.InterfaceLocation.HEADERBAR_START:
				headerbar.pack_start (widget);
				break;

			case Core.InterfaceLocation.HEADERBAR_END:
				headerbar.pack_end (widget);
				break;

			default:
				break;

		}
	}

	public void activate_view (Virtaus.View.AbstractView? view)
	{
		// Remove old widgets from headerbar
		foreach (var child in headerbar.get_children ())
		{
			if (child != menu_button)
				headerbar.remove (child);
		}

		headerbar.title = view.get_title ();
		headerbar.subtitle = view.get_subtitle ();

		stack.set_visible_child_name (view.get_name ());

		view.activated ();
	}

  private void setup_gmenu() {
		var preferences = new GLib.SimpleAction("preferences", null);
  	var about = new GLib.SimpleAction("about", null);
  	
    	/* Connect the 'activate' signal to the
	   * signal handler (aka. callback).
	   */
	  about.activate.connect (on_about_activate);
	  preferences.activate.connect (on_preferences_activate);
	  this.add_action(about);
	  this.add_action(preferences);
  }

  /* Show preferences dialog */
  private void on_preferences_activate ()
  {
		Virtaus.PreferencesDialog dialog;

		dialog = new Virtaus.PreferencesDialog ();

		dialog.transient_for = this;
	  dialog.modal = true;
	  dialog.destroy_with_parent = true;

		dialog.present ();
  }

  // About button
  private void on_about_activate ()
  {
    const string[] authors = {
			"Cláudia Regina Garcia Vicentini <clgarciatm2012@gmail.com>",
      "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };
    
    const string[] artists = {
    	"Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
    };
	
	  const string[] documenters = {
		  "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>",
      null
	  };

	  var dialog = new Gtk.AboutDialog();
	  dialog.authors = authors;
	  dialog.artists = artists;
	  dialog.documenters = documenters;

	  dialog.program_name = _("Virtaus");
	  dialog.comments = _("Manage your creativity, the modular way.");
	  dialog.copyright = _("Copyright \xc2\xa9 2012-2014 The Virtaus Project authors\n");
	  dialog.version = "0.0.1";
	  dialog.license_type = Gtk.License.GPL_3_0;
	  dialog.wrap_license = true;
	  dialog.website = "https://github.com/GeorgesStavracas/Virtaus";
	  dialog.website_label = _("Virtaus website");

		try
		{
			dialog.logo = new Gdk.Pixbuf.from_resource("/apps/virtaus/resources/icon.png");
		}
		catch (GLib.Error e)
		{
			dialog.logo = null;
		}

	  dialog.transient_for = this;
	  dialog.modal = true;
	  dialog.destroy_with_parent = true;
	
	  dialog.present();
  }
}

}
