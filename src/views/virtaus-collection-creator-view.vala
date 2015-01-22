/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-collection-view.c
 * Copyright (C) 2014 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
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

namespace Virtaus.View
{

[GtkTemplate (ui = "/apps/virtaus/resources/collection-creator.ui")]
public class CollectionCreatorView : Gtk.Frame, Virtaus.View.AbstractView
{
  private Virtaus.Application app;

  private Gtk.Button cancel_button;
  private Gtk.Button back_button;
  private Gtk.Button continue_button;
  private Gtk.Box button_box;

  public CollectionCreatorView (Virtaus.Application app)
  {
    this.app = app;

    /* buttons */
    this.cancel_button = new Gtk.Button.with_label (_("Cancel"));

    this.button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
    this.back_button = new Gtk.Button.with_label (_("Back"));
    this.continue_button = new Gtk.Button.with_label (_("Continue"));
    this.continue_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

    this.button_box.add (this.back_button);
    this.button_box.add (this.continue_button);
    this.button_box.show_all ();

    this.show_all ();
  }

  public void search (string? query)
  {
    /* TODO: implement search */
  }

  public void activate ()
  {
    register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR, this.cancel_button, Gtk.Align.START, Gtk.Align.START);
    register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR, this.button_box, Gtk.Align.END, Gtk.Align.START);
  }
}
}
