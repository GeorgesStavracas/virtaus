/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-view.c
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

public enum Mode
{
  DEFAULT,
  SEARCH,
  SELECTION
}

public interface AbstractView : GLib.Object
{
  /**
   * Whether the view implements {@link Virtaus.View.Mode.SEARCH} mode.
   *
   * Views that can handle search should set this to {@link true}.
   */
  public abstract bool has_search {get; set; default = false;}

  /**
   * Whether the view implements {@link Virtaus.View.Mode.SELECTION} mode.
   *
   * Views that can handle selection should set this to {@link true}.
   */
  public abstract bool has_selection  {get; set; default = false;}

  /**
   * The current view {@link Virtaus.View.Mode}.
   *
   * Views that can handle search should set this to {@link true}.
   *
   * @see Virtaus.View.Mode
   */
  public abstract Mode mode  {get; set; default = Mode.DEFAULT;}

  /**
   * Fired when the view wants the window to register a widget.
   */
	public signal void register_widget (Virtaus.Core.InterfaceLocation location,
	                                    Gtk.Widget                     widget,
	                                    Gtk.Align                      halign,
	                                    Gtk.Align                      valign);

  /**
   * Fired when the view wants to change the current view.
   */
  public signal void show_view       (string                        view_name);

  /**
   * When the window receives keyboard input, is must ask
   * the search bar whether it'll handle that or not.
   */
  public abstract Gtk.SearchBar get_search_bar ();

  /**
   * Called when the view is set as the current active view.
   */
  public abstract new void activate   ();

  /**
   * Called when the view is not the active view anymore.
   */
  public abstract new void deactivate ();
}

}
