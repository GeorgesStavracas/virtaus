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
  private Gtk.Stack views_stack;
  [GtkChild]
  private Gtk.HeaderBar headerbar;
  [GtkChild]
  private Gtk.ActionBar actionbar;

  private Gee.HashMap<string, Virtaus.View.AbstractView> views = new Gee.HashMap<string, Virtaus.View.AbstractView> ();
  private Gee.HashMap<Gtk.Widget, Virtaus.Core.InterfaceLocation> registered_widgets = new Gee.HashMap<Gtk.Widget, Virtaus.Core.InterfaceLocation> ();

  public Window (Virtaus.Application app)
  {
    Object(application: app);

    /* create the actions used by this window */
    create_actions ();

    create_views (app);
  }


  [GtkCallback]
  private bool key_pressed (Gdk.EventKey event)
  {
    message ("key pressed");
    return false;
  }

  [GtkCallback]
  private bool window_state_changed (Gdk.EventWindowState event)
  {
    message ("window state");
    return false;
  }

  [GtkCallback]
  private void visible_child_changed ()
  {
    /* Remove every previously registered widget */
    foreach (Gtk.Widget widget in registered_widgets.keys)
    {
      Core.InterfaceLocation location;
      location =  registered_widgets.get (widget);

      switch (location)
      {
        case Virtaus.Core.InterfaceLocation.HEADERBAR:
          headerbar.remove (widget);
          break;

        case Virtaus.Core.InterfaceLocation.ACTIONBAR:
          actionbar.remove (widget);
          break;
      }
    }

    /* Clear the widget list */
    registered_widgets.clear ();

    registered_widgets = new Gee.HashMap<Gtk.Widget, Virtaus.Core.InterfaceLocation> ();
  }

  private void create_actions ()
  {
    SimpleAction about, preferences;

    about = new SimpleAction ("about", null);
    preferences = new SimpleAction ("preferences", null);

    this.add_action (about);
    this.add_action (preferences);

    preferences.activate.connect (()=>
    {
      on_preferences_activate ();
    });

    about.activate.connect (()=>
    {
      on_about_activate ();
    });
  }

  private void create_views (Virtaus.Application app)
  {
    Virtaus.View.AbstractView view;

    /* collection view */
    view = new Virtaus.View.CollectionView (app);
    view.register_widget.connect (register_widget);
    view.show_view.connect (show_stack_child);

    views.set ("collections", view);
    views_stack.add_named (view as Gtk.Widget, "collections");
    views_stack.visible_child = view as Gtk.Widget;

    /* collection wizard view */
    view = new Virtaus.View.CollectionCreatorView (app);
    view.register_widget.connect (register_widget);
    view.show_view.connect (show_stack_child);

    views.set ("collection-creator", view);
    views_stack.add_named (view as Gtk.Widget, "collection-creator");
  }

  private void register_widget (Virtaus.Core.InterfaceLocation location, Gtk.Widget widget,
                                Gtk.Align halign, Gtk.Align valign)
  {
    switch (location)
    {
      case Virtaus.Core.InterfaceLocation.HEADERBAR:
        if (halign == Gtk.Align.START)
          headerbar.pack_start (widget);
        else if (halign == Gtk.Align.END)
          headerbar.pack_end (widget);
        break;

      case Virtaus.Core.InterfaceLocation.ACTIONBAR:
        if (halign == Gtk.Align.START)
          actionbar.pack_start (widget);
        else if (halign == Gtk.Align.CENTER)
          actionbar.set_center_widget (widget);
        else if (halign == Gtk.Align.END)
          actionbar.pack_end (widget);

        actionbar.show ();

        break;
    }

    registered_widgets.set (widget, location);
    widget.show ();
  }

  /* Show preferences dialog */
  private void on_preferences_activate ()
  {
		Virtaus.PreferencesDialog dialog;

		dialog = new Virtaus.PreferencesDialog ();

		dialog.set_transient_for (this);
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
	  dialog.copyright = _("Copyright \xc2\xa9 2012-2015 The Virtaus Project authors\n");
	  dialog.version = "0.0.1";
	  dialog.license_type = Gtk.License.GPL_3_0;
	  dialog.wrap_license = true;
	  dialog.website = "https://github.com/GeorgesStavracas/virtaus";
	  dialog.website_label = _("Virtaus website");
	  dialog.transient_for = this;
	  dialog.modal = true;
	  dialog.destroy_with_parent = true;
	
	  dialog.present();
  }
}

}
