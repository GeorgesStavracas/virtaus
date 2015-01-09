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
  public Window (Virtaus.Application app) {
  	Object(application: app);
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
