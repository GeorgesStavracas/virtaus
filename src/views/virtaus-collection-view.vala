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

[GtkTemplate (ui = "/apps/virtaus/resources/window.ui")]
public class CollectionView : Gtk.Frame, Virtaus.View.AbstractView
{
	/* Title & Subtitle */
	protected string title;
	protected string subtitle;
	private Virtaus.Window window;

	/* Buttons */
	private Gtk.Button new_collection_button;
	private Gtk.Button cancel_button;
	private Gtk.Button back_button;
	private Gtk.Button next_button;

	/* Pages */
	[GtkChild]
	private Gtk.Stack stack;
	[GtkChild]
	private Gtk.Stack creation_stack;
	private Gtk.Builder builder;
	private string[] pages;
	private int current_page;

	/* Icon & List handlers */
	[GtkChild]
	private Gtk.FlowBox flowbox;

	public CollectionView (Virtaus.Window window)
	{
		/* Titles */
		title = _("Collections");
		subtitle = _("Select a collection or create a new one");
		this.window = window;

		window.object_selected.connect (on_object_selected);

		/* Buttons */
		builder = new Gtk.Builder.from_resource ("/apps/virtaus/resources/collection_buttons.ui");

		new_collection_button = builder.get_object ("new_collection_button") as Gtk.Button;
		next_button = builder.get_object ("next_button") as Gtk.Button;
		cancel_button = builder.get_object ("cancel_button") as Gtk.Button;
		back_button = builder.get_object ("back_button") as Gtk.Button;

		new_collection_button.clicked.connect (on_new_collection_button_clicked);
		next_button.clicked.connect (on_next_button_clicked);
		cancel_button.clicked.connect (on_cancel_button_clicked);
		back_button.clicked.connect (on_back_button_clicked);

		builder = null;

		/* Setup pages */
		pages = {"home_page", "data_page", "model_page", "info_page"};
		current_page = 0;

		/* Main page (icon view) */
		flowbox.child_activated.connect (on_child_activated);

		/* TEST */
		for (int i = 0; i < 50; i++)
		{
			var test = new CollectionIconChild ();
			flowbox.add (test);
		}

		flowbox.unselect_all ();
		this.show_all ();
	}

	public string get_name ()
  {
		return "collection";
  }

  public string get_title ()
  {
		return title;
  }

  public string? get_subtitle ()
  {
		return subtitle;
  }

  private void on_child_activated (Gtk.FlowBoxChild child)
  {
		window.object_selected (Virtaus.Core.DataType.COLLECTION, null);
  }

  public void activated ()
  {
		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_START, new_collection_button);
		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_START, cancel_button);
		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_END, next_button);
		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_END, back_button);

		flowbox.unselect_all ();
  }

  private void on_new_collection_button_clicked ()
  {
		title = _("Create a new collection");
		subtitle = "";

		/* Change window mode */
		window.change_mode (Virtaus.WindowMode.CREATION);

		/* Hide uneccessary buttons */
		new_collection_button.hide ();

		/* Show other buttons */
		cancel_button.show ();
		back_button.show ();
		next_button.show ();

		current_page = 0;
		stack.visible_child_name = "creation_page";

		back_button.sensitive = (current_page > 0);
		next_button.sensitive = (current_page < pages.length - 1);
  }

  private void on_object_selected (Virtaus.Core.DataType type, GLib.Object? object)
  {
		/* Unselect item after 1s */
		GLib.SourceFunc unselect = () => {
			flowbox.unselect_all ();
			return false;
		};
		GLib.Timeout.add (1000, unselect, GLib.Priority.DEFAULT);

		/* Change view */
		if (type == Virtaus.Core.DataType.NONE)
			window.activate_view (this);
	}

  private void on_cancel_button_clicked ()
  {
		title = _("Collections");
		subtitle = _("Select a collection or create a new one");

		/* Change window mode */
		window.change_mode (Virtaus.WindowMode.NORMAL);

		/* Hide uneccessary buttons */
		new_collection_button.show ();

		/* Show other buttons */
		cancel_button.hide ();
		back_button.hide ();
		next_button.hide ();

		current_page = 0;
		stack.visible_child_name = "collections_page";
  }

  private void on_next_button_clicked ()
  {
		current_page++;
		creation_stack.visible_child_name = pages[current_page];

		back_button.sensitive = (current_page > 0);
		next_button.sensitive = (current_page < pages.length - 1);
  }

	private void on_back_button_clicked ()
  {
		current_page--;
		creation_stack.visible_child_name = pages[current_page];

		back_button.sensitive = (current_page > 0);
		next_button.sensitive = (current_page < pages.length - 1);
  }

  public void deactivated ()
	{
		register_menu (null);
	}
}

[GtkTemplate (ui = "/apps/virtaus/resources/collection_child.ui")]
public class CollectionIconChild : Gtk.Overlay
{
	[GtkChild]
	private Gtk.Label author_label;
	[GtkChild]
	private Gtk.Label name_label;

	public string collection_name {public get; public set; default = "";}
	public string author {public get; public set; default = "";}

	public CollectionIconChild ()
	{
		author_label.bind_property ("label", this, "author");
		name_label.bind_property ("label", this, "collection_name");
	}
}

}
