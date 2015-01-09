/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-preferences-dialog.c
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

[GtkTemplate (ui = "/apps/virtaus/resources/preferences.ui")]
public class Virtaus.PreferencesDialog : Gtk.Dialog
{
	[GtkChild]
	private Gtk.HeaderBar headerbar;

  public PreferencesDialog ()
  {
    /* Setup dialog headerbar */
    this.set_titlebar (headerbar);

    this.show_all ();
  }
}
