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

[GtkTemplate (ui = "/apps/virtaus/resources/collections.ui")]
public class CollectionView : Gtk.Frame, Virtaus.View.AbstractView
{
  private Virtaus.Application app;

  private Gtk.Button create_button;

  [GtkChild]
  private Gtk.SearchBar searchbar;

  /**
   * Enable the search.
   */
  public bool has_search
  {
    get {return true;}
  }

  /**
   * Enable selection mode.
   */
  public bool has_selection
  {
    get {return true;}
  }

  /**
   * {@link Virtaus.View.Mode} implementation.
   */
  private Mode _mode = Mode.DEFAULT;
  public Mode mode
  {
    get {return _mode;}
    set
    {
      _mode = value;
    }
  }

  public Gtk.SearchBar? search_bar
  {
    get {return this.searchbar;}
  }

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

  public new void activate ()
  {
    register_widget (Virtaus.WindowLocation.HEADERBAR, this.create_button, Gtk.Align.START, Gtk.Align.START);
  }

  public void deactivate ()
  {
    /* TODO: something to implement here? */
  }

  private void create_collection_clicked_cb ()
  {
    show_view ("collection-creator");
  }
}
}
