/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-category-view.c
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

public class CategoryView : Gtk.Stack, Virtaus.View.AbstractView
{
	/* Title & Subtitle */
	private string title;
	private string? subtitle;
	private Virtaus.Window window;

	/* Buttons */
	private Gtk.Button new_category_button;
	private Gtk.Button new_set_button;
	private Gtk.Button back_button;
	private Gtk.StackSwitcher stack_switcher;

	/* Pages */
	private Gtk.Builder builder;

	/* Icon & List handlers */
	private Gtk.Stack stack;

	public CategoryView (Virtaus.Window parent)
	{
		/* Titles */
		title = "Category";
		subtitle = null;
		this.window = parent;

		/* Setup Builder */
		builder = new Gtk.Builder.from_resource ("/apps/virtaus/resources/category.ui");

		window.object_selected.connect (on_object_selected);

		this.show_all ();
	}

	public string get_name ()
  {
		return "category";
  }

  public string get_title ()
  {
		return title;
  }

  public string? get_subtitle ()
  {
		return subtitle;
  }

  private void on_object_selected (Virtaus.Core.DataType type, GLib.Object? object)
  {
		if (type == Virtaus.Core.DataType.COLLECTION)
		{
			/*
			if (! (object is Virtaus.Core.Collection))
				return;
			*/
			window.activate_view (this);
		}
  }

  public void activated ()
  {
		/* Fetch buttons from UI file */
		new_category_button = builder.get_object ("new_category_button") as Gtk.Button;
		new_set_button = builder.get_object ("new_set_button") as Gtk.Button;
		back_button = builder.get_object ("back_button") as Gtk.Button;

		back_button.clicked.connect (on_back_button_clicked);

		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_START, back_button);
		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_START, new_category_button);
		register_widget (Virtaus.Core.InterfaceLocation.HEADERBAR_START, new_set_button);
  }

	private void on_back_button_clicked ()
	{
		window.object_selected (Virtaus.Core.DataType.NONE, null);
	}

  public void deactivated ()
	{
		register_menu (null);
	}
}

}
