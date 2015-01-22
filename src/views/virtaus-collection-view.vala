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

public class CollectionView : Gtk.Frame, Virtaus.View.AbstractView
{
  private Virtaus.Application app;

  private Gtk.Button create_button;

  public CollectionView (Virtaus.Application app)
  {
    this.app = app;

    /* create collection button */
    this.create_button = new Gtk.Button.with_label ("New collection");
    this.create_button.get_style_context ().add_class ("suggested-action");
    this.create_button.clicked.connect (create_collection_clicked_cb);

    this.show_all ();
  }

  public void search (string? query)
  {
    /* TODO: implement search */
  }

  public void activate ()
  {
    register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR, this.create_button, Gtk.Align.START, Gtk.Align.START);
  }

  private void create_collection_clicked_cb ()
  {
    show_view ("collection-creator");
  }
}
}
