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

  [GtkChild]
  private Gtk.Stack stack;

  /**
   * Disable the search.
   */
  public bool has_search
  {
    get {return false;}
  }

  /**
   * Disable selection mode.
   */
  public bool has_selection
  {
    get {return false;}
  }

  public Gtk.SearchBar? search_bar
  {
    get {return null;}
  }

  /**
   * {@link Virtaus.View.Mode} implementation.
   */
  public Mode mode
  {
    get {return Mode.DEFAULT;}
    set {}
  }

  private string[] pages = {"source_selection", "project_info", "additional_info", "review"};
  private int active_page = 0;

  private Gtk.Button cancel_button;
  private Gtk.Button back_button;
  private Gtk.Button continue_button;
  private Gtk.Box button_box;

  public CollectionCreatorView (Virtaus.Application app)
  {
    this.app = app;

    /* buttons */
    this.cancel_button = new Gtk.Button.with_label (_("Cancel"));
    this.cancel_button.clicked.connect (cancel_button_clicked_cb);

    this.button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

    this.back_button = new Gtk.Button.with_label (_("Back"));
    this.back_button.clicked.connect (page_button_clicked_cb);
    this.back_button.sensitive = false;

    this.continue_button = new Gtk.Button.with_label (_("Continue"));
    this.continue_button.clicked.connect (page_button_clicked_cb);
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

  public new void activate ()
  {
    active_page = 0;
    update_page ();

    register_widget (Virtaus.WindowLocation.HEADERBAR, this.cancel_button, Gtk.Align.START, Gtk.Align.START);
    register_widget (Virtaus.WindowLocation.HEADERBAR, this.button_box, Gtk.Align.END, Gtk.Align.START);
  }

  public void deactivate ()
  {
    /* TODO: something to implement here? */
  }

  private void cancel_button_clicked_cb ()
  {
    show_view ("collections");
  }

  private void page_button_clicked_cb (Gtk.Button button)
  {
    if (button == this.back_button)
      active_page--;
    else
      active_page++;

    update_page ();
  }

  private void update_page ()
  {
    if (active_page < pages.length)
    {
      stack.visible_child_name = pages[active_page];
      back_button.sensitive = (active_page != 0);
      continue_button.label = (active_page == pages.length - 1 ? _("Create") : _("Continue"));
    }
    else
    {
      message ("create collection");
      active_page--;
    }
  }
}
}
