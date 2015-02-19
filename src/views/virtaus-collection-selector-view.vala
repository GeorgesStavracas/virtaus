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

using Gee;

namespace Virtaus.View
{

[GtkTemplate (ui = "/apps/virtaus/resources/collection-selector.ui")]
public class CollectionSelectorView : Gtk.Frame, Virtaus.View.AbstractView
{
  private Virtaus.Application app;

  private Gtk.Button create_button;
  private Gtk.Button remove_collection_button;

  [GtkChild]
  private Gtk.SearchBar searchbar;
  [GtkChild]
  private Gtk.Viewport viewport;

  private Virtaus.SelectableIconView iconview;

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
      if (_mode != value)
      {
        _mode = value;

        create_button.visible = (_mode == Mode.DEFAULT);

        if (_mode == Mode.DEFAULT)
        {
          remove_widget (remove_collection_button);
        }
        else
        {
          register_widget (Virtaus.WindowLocation.ACTIONBAR, remove_collection_button, Gtk.Align.END, Gtk.Align.CENTER);
        }

        this.notify_property ("mode");
      }
    }
  }

  public Gtk.SearchBar? search_bar
  {
    get {return this.searchbar;}
  }

  /**
   * Title and subtitle.
   */
  public string? title {get {return _("Welcome to Virtaus");}}
  public string? subtitle {get {return _("Select a project or create a new one");}}
  public Gtk.Widget? titlebar_widget {get {return null;}}

  public CollectionSelectorView (Virtaus.Application app)
  {
    this.app = app;

    /* create collection button */
    this.create_button = new Gtk.Button.with_label ("New collection");
    this.create_button.get_style_context ().add_class ("suggested-action");
    this.create_button.clicked.connect (create_collection_clicked_cb);

    /* remove collection button */
    this.remove_collection_button = new Gtk.Button.with_label (_("Delete"));
    this.remove_collection_button.get_style_context ().add_class ("destructive-action");
    this.remove_collection_button.clicked.connect (remove_collection_clicked_cb);

    // Iconview
    iconview = new Virtaus.SelectableIconView ();
    iconview.set_item_width (256);
    iconview.bind_property ("mode", this, "mode", BindingFlags.BIDIRECTIONAL);
    iconview.item_activated.connect (item_activated_cb);

    viewport.add (iconview);

    this.show_all ();
  }

  public void search (string? query)
  {
    /* TODO: implement search */
  }

  public new void activate ()
  {
    /* Clear all items */
    (iconview.model as Gtk.ListStore).clear ();

    /* Repopulate the grid */
    foreach (Core.ExtensionInfo info in app.manager.data_sources.values)
    {
      Core.DataSource source = info.instance as Core.DataSource;

      foreach (Core.Collection collection in source.collections)
      {
        Virtaus.CollectionIconItem item = new Virtaus.CollectionIconItem (collection);

        iconview.add_item (item);
      }
    }

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

  private void remove_collection_clicked_cb ()
  {
    message ("Removing collections");
  }

  private void item_activated_cb (Gtk.TreePath? path)
  {
    Virtaus.CollectionIconItem item;
    Gtk.TreeIter? iter;

    iconview.model.get_iter (out iter, path);
    iconview.model.get (iter, 1, out item);

    //show_view ("category");
  }
}
}