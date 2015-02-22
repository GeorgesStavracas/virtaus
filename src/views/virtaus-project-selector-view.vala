/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-project-view.c
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

[GtkTemplate (ui = "/apps/virtaus/resources/project-selector.ui")]
public class ProjectSelectorView : Gtk.Frame, Virtaus.View.AbstractView
{
  private Virtaus.Application app;

  private Gtk.Button create_button;
  private Gtk.Button remove_project_button;

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
          remove_widget (remove_project_button);
        else
          register_widget (Virtaus.WindowLocation.ACTIONBAR, remove_project_button, Gtk.Align.END, Gtk.Align.CENTER);

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

  public ProjectSelectorView (Virtaus.Application app)
  {
    this.app = app;

    /* create project button */
    this.create_button = new Gtk.Button.with_label ("New project");
    this.create_button.get_style_context ().add_class ("suggested-action");
    this.create_button.clicked.connect (create_project_clicked_cb);

    /* remove project button */
    this.remove_project_button = new Gtk.Button.with_label (_("Delete"));
    this.remove_project_button.get_style_context ().add_class ("destructive-action");
    this.remove_project_button.sensitive = false;
    this.remove_project_button.clicked.connect (remove_project_clicked_cb);

    // Iconview
    iconview = new Virtaus.SelectableIconView ();
    iconview.set_item_width (256);
    iconview.bind_property ("mode", this, "mode", BindingFlags.BIDIRECTIONAL);
    iconview.item_activated.connect (item_activated_cb);
    iconview.selection_changed.connect (iconview_selection_changed_cb);

    viewport.add (iconview);

    this.show_all ();
  }

  public void search (string? query)
  {
    /* TODO: implement search */
  }

  public new void activate ()
  {
    /* populate the grid */
    populate_grid ();

    register_widget (Virtaus.WindowLocation.HEADERBAR, this.create_button, Gtk.Align.START, Gtk.Align.START);
  }

  public void deactivate ()
  {
    /* TODO: something to implement here? */
  }

  private void populate_grid ()
  {
    /* Clear all items */
    (iconview.model as Gtk.ListStore).clear ();

    /* Repopulate the grid */
    foreach (Cream.ExtensionInfo info in app.manager.data_sources.values)
    {
      Cream.DataSource source = info.instance as Cream.DataSource;

      foreach (Cream.Project project in source.projects)
      {
        Virtaus.ProjectIconItem item = new Virtaus.ProjectIconItem (project);

        iconview.add_item (item);
      }
    }

    iconview.queue_draw ();
  }

  private void create_project_clicked_cb ()
  {
    show_view ("project-creator");
  }

  private void remove_project_clicked_cb ()
  {
    Gtk.MessageDialog dialog;
    Gtk.Button cancel_button, delete_button;
    int response;

    // Buttons
    cancel_button = new Gtk.Button.with_label (_("Cancel"));

    delete_button = new Gtk.Button.with_label (_("Remove"));
    delete_button.get_style_context ().add_class ("destructive-action");

    cancel_button.show ();
    delete_button.show ();

    // Dialog
    dialog = new Gtk.MessageDialog (this.get_toplevel () as Gtk.Window, Gtk.DialogFlags.MODAL |
                                    Gtk.DialogFlags.USE_HEADER_BAR, Gtk.MessageType.QUESTION, Gtk.ButtonsType.NONE,
                                    _("Remove the selected projects?"));
    dialog.secondary_text = _("The files will be preserved.");

    dialog.add_action_widget (cancel_button, Gtk.ResponseType.CANCEL);
    dialog.add_action_widget (delete_button, Gtk.ResponseType.ACCEPT);

    response = dialog.run ();

    if (response == Gtk.ResponseType.ACCEPT)
    {
      GLib.List<Gtk.TreePath> selected_items;

      selected_items = iconview.get_selected_items ();

      selected_items.foreach ((path)=>{
        Virtaus.ProjectIconItem item;
        Cream.DataSource source;
        Gtk.TreeIter? iter;

        iconview.model.get_iter (out iter, path);
        iconview.model.get (iter, 1, out item);

        source = item.project.source;
        source.remove (item.project);
      });

      /* repopulate the grid */
      populate_grid ();

      mode = Mode.DEFAULT;
    }

    dialog.destroy ();
  }

  private void iconview_selection_changed_cb ()
  {
    GLib.List<Gtk.TreePath> selected_items;
    uint length;

    selected_items = iconview.get_selected_items ();
    length = selected_items.length ();

    remove_project_button.sensitive = (length > 0);
  }

  private void item_activated_cb (Gtk.TreePath? path)
  {
    Virtaus.ProjectIconItem item;
    Gtk.TreeIter? iter;

    iconview.model.get_iter (out iter, path);
    iconview.model.get (iter, 1, out item);

    //show_view ("category");
  }
}
}
